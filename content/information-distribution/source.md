---
title: "Source"
weight: 2
---

A source is an entity holding the responsibility of publishing information
through the federation.

A source **must** register itself as such on the federation. This **must** be
done through the publication of a `network.informo.source` state event. The
event's state key **must** be the ID of the source's current Matrix user. The
content of this event **must** be provided using the following structure:

## Matrix event `network.informo.source`

| Parameter     | Type              | Req. | Description                                                                                                                                                                                                        |
|:--------------|:------------------|:----:|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `name`        | `LocalisedString` |  x   | Name of the source.                                                                                                                                                                                                |
| `owner`       | `LocalisedString` |  x   | The organisation or individual maintaining this source.                                                                                                                                                            |
| `l10n`        | `Lang`            |  x   | Languages of the source's publications.                                                                                                                                                                            |
| `sig_keys`    | `Keys`            |  x   | Public keys the source will use to cryptographically sign its articles.                                                                                                                                            |
| `prev_user`   | `PrevUser`        |      | Previous Matrix user the source used to publish information. See [below]({{<ref "#change-of-matrix-user">}}) for additional information on how a source can change the Matrix user it uses to publish information. |
| `website`     | `string`          |      | URL of the source's website, if there's one.                                                                                                                                                                       |
| `description` | `LocalisedString` |      | Short description of the source and its publications.                                                                                                                                                              |
| `logo`        | `string`          |      | Logo of the source. If provided, must be a [`mxc://` URL](https://matrix.org/docs/spec/client_server/r0.4.0.html#id112).                                                                                           |
| `country`     | `string`          |      | Country of the source's owner. If provided, **must** be compliant with [ISO 3166](https://www.iso.org/iso-3166-country-codes.html).                                                                                |
| `custom`      | `object`          |      | Additional information for custom client implementations.                                                                                                                                                          |

Where:

<!--
    The definitions of `LocalisedString`, `Keys` and `PrevUser` here are the
    same as in trust-authority.md. People changing any (or all of them) might
    want to also change it there (or remove this warning).
-->
* `LocalisedString` is a map associating a [RFC
  5646](https://tools.ietf.org/html/rfc5646)-compliant language (and variant)
  identifier to a localisation of the string in the language the identifier
  refers to.
* `Lang` is a map associating a [RFC
  5646](https://tools.ietf.org/html/rfc5646)-compliant language (and variant)
  identifier to the Matrix user ID of the sub-source that handles the
  publication of articles in this language (and variant). This map **must**
  contain at least one element. More information on localised sub-sources and
  examples are available [below]({{<ref "#localisation">}}).
* `Keys` is a map associating a public key to the algorithm used in order to
  generate a signature with this key.
* `PrevUser` is a map using the following structure:

| Parameter   | Type     | Req. | Description                                                                                                                                                                                                                                                                                                            |
|:------------|:---------|:----:|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `user_id`   | `string` |  x   | ID of the Matrix user this source previously used to publish information.                                                                                                                                                                                                                                              |
| `event_id`  | `string` |  x   | ID of the latest event published by the source's original administrator using the source's previous user.                                                                                                                                                                                                              |
| `sig_algo`  | `string` |      | Algorithm used to generate `signature`.                                                                                                                                                                                                                                                                                |
| `sig_key`   | `string` |      | Public key to use when verifying `signature`. **Should** be one of the source's previous user's public keys.                                                                                                                                                                                                           |
| `signature` | `string` |      | Signature generated from a `PrevUserSign` map derived from the current `PrevUser` map, using the key specified in `sig_key` and the algorithm specified in `sig_algo`, and following the instructions described [here]({{<ref "/information-distribution/signature#signing-json-data">}}) (under "Signing JSON data"). |

* `PrevUserSign` is a map using the following structure:

| Parameter       | Type     | Req. | Description                                                                                                                                                            |
|:----------------|:---------|:----:|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `prev_user_id`  | `string` |  x   | ID of the Matrix user this source previously used to publish information. **Must** match the `user_id` of the current `PrevUser` map.                                  |
| `prev_event_id` | `string` |  x   | ID of the latest event published by the source's original administrator using the source's previous user. **Must** match the `event_id` of the current `PrevUser` map. |
| `new_user_id`   | `string` |  x   | ID of the Matrix user this source currently uses to publish information. **Must** match the ID of the new user in use by the source.                                   |

Each time one of the source's properties changes, it **must** publish a new
registration event, and every trust authority certifying the trustworthiness of
this source **must** generate a new signature from the new event. This signature
lives in a [TA's registration event]({{<ref
"/trust-management/trust-authority#trust-authority-registration">}}).

If a source doesn't provide a logo, client implementations **can** use the
[avatar](https://matrix.org/docs/spec/client_server/r0.4.0.html#get-matrix-client-r0-profile-userid-avatar-url)
of its Matrix user instead.

## Cryptographic private keys getting compromised

Every trust authority certifying a source's trustworthiness **must** be operated
by an organisation or individual the source trusts and is in contact with
outside of Informo. If at least one of a source's private keys gets compromised,
the source **must** update its list of public signature verification keys by
publishing a new registration event containing the updated list, and every trust
authority trusting the source **must** compute and issue a new signature taking
the updated list of keys into account. The reason behind this is to encourage
trust authorities to communicate with their trusted sources, estimate how much
compromised the source is (i.e. one key vs all of the keys vs the source's
entire Matrix account), and take the actions it deems necessary.

In such an event, client implementations **should** consider articles posted
prior to the key being declared as compromised as probably not having been
tampered with, with no way to be entirely sure about it.

## Change of Matrix user

A source or sub-source might have to change the Matrix user it uses to publish
information at some points in its life time. This can happen for many reason:
the homeserver it was registered on went down, or got compromised, or got
isolated from the rest of the federation...

In such an event, the source or sub-source **must** publish a new registration
event from its new Matrix user with the `prev_user` property set. The value of
this property **must** follow the specification above for the `PrevUser` type,
with the `user_id` property's value being the source's or sub-source's previous
user's, and the `event_id` property's value being the ID of the latest event
emitted prior to the change.

This property **must** be used by client implementations to bind the previous
user to the new one, considering both as the same entity, following the rules
described below. A missing `prev_user` property simply means that the source or
sub-source didn't previously use another Matrix account to publish information.

If the entity is a source (and not a sub-source), trust authorities certifying
it as trustworthy **must** verify that the change comes from the source's
original administrator (preferably using a different medium than Informo) and
update their list of trusted entities by removing the previous user from it, and
adding the new one to it. The signature associated with the new user **must** be
generated from the new user's registration event.

### Binding between a source and its new user

If the `signature` property from the `prev_user` property in the new user's
registration event can be verified using a public cryptographic key that was
already in the previous user's registration event's `sig_keys` property, then
client implementations **should** consider the binding between a source (or a
sub-source) and its new user to be valid.

If such a condition couldn't be met, client implementations **must** wait until
all of the TAs that were initially trusting the source's previous user update
their list of trusted sources with one including the source's new user, before
being able to take any automated action regarding the validity of the binding.

While waiting for such an update, client implementations **can** display an
informative message to their user explaining the nature of the ongoing
transition, and **can** offer them the possibility to display the source's (or
sub-source's) timeline as it would be if the update was already done. This
switch of display **must** come from a manual operation from a user who has been
informed on the migration.

Once the binding between a source (or a sub-source) and its new user is
considered valid, client implementations **must** display, as the timeline of
publications from this source (or sub-source), the articles published by the
source's (or sub-source's) previous user up to the event which ID matches the
`event_id` property from its new user's registration event's `prev_user`
property, then all articles published after the said event by the source's (or
sub-source's) new user.

{{% notice tip %}}
If a trust authority certifying the source or sub-source that's changing its
Matrix user as trustworthy deems it necessary, it can also add the source's (or
sub-source's) previous user to its blacklist, as documented [in the related
section]({{< ref "/trust-management/trust-authority#blacklisting" >}}).
{{% /notice %}}

## Localisation

An information website might want to publish articles in more than one language.
In such a case, it **can** create sub-sources, each of which handling the
publication of its articles in one language. A source, regardless of whether it
is a sub-source or not, **must not** publish articles in more than one language.

A sub-source is an entity similar to a source, with the exception that it
**must** be referenced to by a source. Each sub-source **must** be a registered
Matrix user, and **must** register itself on the Matrix room through the
publication of a `network.informo.subsource` state event, with the sub-source's
Matrix user ID as the event's state key. The event's content **must** be
embedded in a [signed Matrix event]({{<ref
"/information-distribution/signature#signed-matrix-event">}}), signed by one of
the parent source's public keys, with its `signed` object using the following
structure:

### Matrix event `network.informo.subsource`

| Parameter     | Type       | Req. | Description                                                                                                                                                                                                            |
|:--------------|:-----------|:----:|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `parent`      | `string`   |  x   | Matrix user ID of the sub-source's parent.                                                                                                                                                                             |
| `sig_keys`    | `Keys`     |  x   | Public keys the sub-source will use to cryptographically sign its articles.                                                                                                                                            |
| `prev_user`   | `PrevUser` |      | Previous Matrix user the sub-source used to publish information. See [above]({{<ref "#change-of-matrix-user">}}) for additional information on how a source can change the Matrix user it uses to publish information. |
| `website`     | `string`   |      | URL of the source's website in this language, if there's one.                                                                                                                                                          |
| `description` | `string`   |      | Short localised description of the source and its publications.                                                                                                                                                        |
| `custom`      | `object`   |      | Additional information for custom client implementations.                                                                                                                                                              |

The parent source **must** then reference the sub-source in its own registration
event, as part of its `l10n` object. This object **can** reference the source
that emitted the `network.informo.source` event, but a Matrix user ID **must
not** be referenced more than once in a source registration's `l10n` object.

{{% notice info %}}
A source **can** register itself as one if its own sub-sources. In this case, it
doesn't need to emit any `network.informo.subsource` event for this specific
sub-source. The articles published by the source acting as one of its
sub-sources **must** be signed using one of the source's public keys.
{{% /notice %}}

If set, client implementations **must** use the value for the `description` and
`website` properties of the `network.informo.subsource` event instead of the
localised description and the website provided in the parent source's
`network.informo.source` event.

Client implementations **must** consider a sub-source as holding the same [trust
level]({{<ref "/trust-management/trust-level">}}) as its parent source, and
therefore **must** consider it at the same location in trust networks as its
parent.

### Example

Let's consider the example of an example website publishing news only in
English, and registering itself as a source with the Matrix user id
`@acmenews:example.com`, and registering itself as its sub-source for the
English language, the `l10n` object would look like this:

```
{
    "en": "@acmenews:example.com"
}
```

{{% notice tip %}}
In this example, `en-US`, `en-GB`, etc. can be used instead of `en` if the
source wants to explicitly specify language variants.
{{% /notice %}}

## Client implementations behaviours regarding sources

Client implementations **should** allow users to subscribe to all of the
articles published by a specific source.

Client implementations **can** display a source and all of its sub-sources as a
single entity with several languages available.

Client implementations **should** allow users to set at least one preferred
language and use it to select the corresponding name and description for sources
that offer a name or a description in this language. If a source doesn't offer
either a name or a description in the user's preferred language, client
implementations **can** select another language to fall back to, by allowing the
user to set a weighted list of preferred languages. If a source only provide its
name or description in one language, client implementations **must** use that
value.

## Full example

Let's consider a news website, named "ACME News", publishing news in both
English and French, each on a localised website. We'll also consider
`@acmenews:example.com` its main Informo source, and `@acmenewsen:example.com`
and `@acmenewsfr:example.com` its sub-sources, handling the publication of
articles, respectively in English and in French. This news website just migrated
from the homeserver `badserver.com` to the `example.com` one, because the former
was managed by people they don't consider as trustworthy.

Here are the state events it needs to emit to properly register all of its
sources.

{{% notice note %}}
Please keep in mind that, although this can look like a troublesome thing to do,
it can easily be automated using one of the existing [SDKs for
Matrix](https://matrix.org/docs/projects/sdks).
{{% /notice %}}

#### `network.informo.source` event

| Emitter                 | State key               |
|:------------------------|:------------------------|
| `@acmenews:example.com` | `@acmenews:example.com` |

```json
{
    "name": {
        "en": "ACME News"
    },
    "owner": {
        "en": "ACME News Group"
    },
    "prev_user": {
        "user_id": "@acmenews:badserver.com",
        "event_id": "!someEvent:badserver.com",
    },
    "website": "https://www.example.com",
    "description": {
        "en": "ACME News is the most amazing dummy news outlet."
    },
    "logo": "mxc://weu.informo.network/AtEuTuVSeIlZQgjEzjGyMDtG",
    "sig_keys": {
        "IlRMeOPX2e0MurIyfWEucYBRVOEEUMrOHqn/8mLqMjA": "ed25519"
    },
    "lang": {
        "en": "@acmenewsen:example.com",
        "fr": "@acmenewsfr:example.com"
    }
}
```

#### `network.informo.subsource` event

| Emitter                   | State key                 |
|:--------------------------|:--------------------------|
| `@acmenewsen:example.com` | `@acmenewsen:example.com` |

```json
{
    "signature": "54ab6f6f18d63ef1",
    "signed": {
        "sender": "@acmenewsen:example.com",
        "room_id": "!LppXGlMuWgaYNuljUr:example.com",
        "type": "network.informo.subsource",
        "state_key": "@acmenewsfr:example.com",
        "signatory": "@acmenews:example.com",
        "signatory_key": "IlRMeOPX2e0MurIyfWEucYBRVOEEUMrOHqn/8mLqMjA",
        "algorithm": "ed25519",
        "content": {
            "parent": "@acmenews:example.com",
            "prev_user": {
                "user_id": "@acmenewsen:badserver.com",
                "event_id": "!someEnglishArticle:badserver.com",
            },
            "website": "https://www.example.com/en",
            "description": "This is the English source for ACME News.",
            "sig_keys": {
                "Noh0oot2chahTheixeuviX6seidiweewahK/8mLeMjA": "ed25519"
            }
        }
    }
}
```

#### `network.informo.subsource` event

| Emitter                   | State key                 |
|:--------------------------|:--------------------------|
| `@acmenewsfr:example.com` | `@acmenewsfr:example.com` |

```json
{
    "signature": "0a1df56f18d63ef1",
    "signed": {
        "sender": "@acmenewsfr:example.com",
        "room_id": "!LppXGlMuWgaYNuljUr:example.com",
        "type": "network.informo.subsource",
        "state_key": "@acmenewsfr:example.com",
        "signatory": "@acmenews:example.com",
        "signatory_key": "IlRMeOPX2e0MurIyfWEucYBRVOEEUMrOHqn/8mLqMjA",
        "algorithm": "ed25519",
        "content": {
            "parent": "@acmenews:example.com",
            "prev_user" : {
                "user_id": "@acmenewsfr:badserver.com",
                "event_id": "!someFrenchArticle:badserver.com",
            },
            "website": "https://www.example.com/fr",
            "description": "Ceci est la source française d'ACME News.",
            "sig_keys": {
                "xee1PahM1jutohz2jiec1keeshoW0GooVei/8mLeMjA": "ed25519"
            }
        }
    }
}
```

Once all of these events have been published, `@acmenewsen:example.com` can
start publishing articles in English, and `@acmenewsfr:example.com` can start
publishing articles in French.

## Alternate example

Let's consider a news website, named "ACME News", publishing news in both
English and French, each on a localised website. We'll also consider
`@acmenews:example.com` its main Informo source, and `@acmenewsfr:example.com`
its sub-source handling the publications of articles in French. The
publication of articles in English is done by ACME News's main source,
`@acmenews:example.com`.

Here are the state events it needs to emit to properly register all of its
sources.

#### `network.informo.source` event

| Emitter                 | State key               |
|:------------------------|:------------------------|
| `@acmenews:example.com` | `@acmenews:example.com` |

```json
{
    "name": {
        "en": "ACME News"
    },
    "owner": {
        "en": "ACME News Group"
    },
    "website": "https://www.example.com",
    "description": {
        "en": "ACME News is the most amazing dummy news outlet. This is also its English source."
    },
    "logo": "mxc://weu.informo.network/AtEuTuVSeIlZQgjEzjGyMDtG",
    "sig_keys": {
        "IlRMeOPX2e0MurIyfWEucYBRVOEEUMrOHqn/8mLqMjA": "ed25519"
    },
    "lang": {
        "en": "@acmenews:example.com",
        "fr": "@acmenewsfr:example.com"
    }
}
```

#### `network.informo.subsource` event

| Emitter                   | State key                 |
|:--------------------------|:--------------------------|
| `@acmenewsfr:example.com` | `@acmenewsfr:example.com` |

```json
{
    "signature": "0a1df56f18d63ef1",
    "signed": {
        "sender": "@acmenewsfr:example.com",
        "room_id": "!LppXGlMuWgaYNuljUr:example.com",
        "type": "network.informo.subsource",
        "state_key": "@acmenewsfr:example.com",
        "signatory": "@acmenews:example.com",
        "signatory_key": "IlRMeOPX2e0MurIyfWEucYBRVOEEUMrOHqn/8mLqMjA",
        "algorithm": "ed25519",
        "content": {
            "parent": "@acmenews:example.com",
            "website": "https://www.example.com/fr",
            "description": "Ceci est la source française d'ACME News.",
            "sig_keys": {
                "xee1PahM1jutohz2jiec1keeshoW0GooVei/8mLeMjA": "ed25519"
            }
        }
    }
}
```

Once both of these events have been published, `@acmenews:example.com` can
start publishing articles in English, and `@acmenewsfr:example.com` can start
publishing articles in French.
