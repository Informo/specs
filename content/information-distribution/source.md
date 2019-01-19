---
title: "Source"
weight: 2
---

A source is an entity holding the responsibility of publishing information
through the Matrix room. Each source **must** be a registered Matrix user, and a
Matrix user **must not** register more than one source, which means there is a
one to one correspondence between a source and its Matrix user.

A source **must** register itself as such on the room. This **must** be done
through the publication of a `network.informo.source` state event. The event's
state key **must** be the ID of the source's Matrix user. The content of this
event **must** be provided using the following model:

## Matrix event `network.informo.source`

| Parameter     | Type              | Req. | Description                                                                                                                                                                                              |
|:--------------|:------------------|:----:|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `name`        | `localisedString` |  x   | Name of the source.                                                                                                                                                                                      |
| `owner`       | `localisedString` |  x   | The company or individual maintaining this source.                                                                                                                                                       |
| `l10n`        | `lang`            |  x   | Languages of the source's publications.                                                                                                                                                                  |
| `sig_algo`    | `string`          |  x   | Algorithm the source will use to cryptographically sign its articles. 🔧                                                                                                                                 |
| `sig_keys`    | `[string]`        |  x   | Public keys the source will use to cryptographically sign its articles. 🔧                                                                                                                               |
| `prev_user`   | `prevUser`        |      | Matrix user the source previously used to publish information. See [below](#change-of-matrix-user) for additional information on how a source can change the Matrix user it uses to publish information. |
| `website`     | `string`          |      | URL of the source's website, if there's one.                                                                                                                                                             |
| `description` | `localisedString` |      | Short description of the source and its publications.                                                                                                                                                    |
| `logo`        | `string`          |      | Logo of the source. If provided, must be a [`mxc://` URL](https://matrix.org/docs/spec/client_server/r0.4.0.html#id112).                                                                                 |
| `country`     | `string`          |      | Country of the source's owner. If provided, **must** be compliant with [ISO 3166](https://www.iso.org/iso-3166-country-codes.html).                                                                      |
| `custom`      | `object`          |      | Additional information for custom client implementations.                                                                                                                                                |

 <!-- 🔧: Need to do some research on Megolm and Matrix APIs around encryption
 and key management -->

Where:

<!--
   The definition of `localisedString` here is the same as in
   trust-authority.md. People changing it might want to also change it there (or
   remove this warning).
-->
* `localisedString` is a map associating a [RFC
  5646](https://tools.ietf.org/html/rfc5646)-compliant language (and variant)
  identifier to a localisation of the string in the language the identifier
  refers to.
* `lang` is a map associating a [RFC
  5646](https://tools.ietf.org/html/rfc5646)-compliant language (and variant)
  identifier to the Matrix user ID of the sub-source that handles the
  publication of articles in this language (and variant). This map **must**
  contain at least one element. More information on localised sub-sources and
  examples are available [below](#localisation).
* `prevUser` is a map using the following structure:

| Parameter  | Type     | Req. | Description                                                                           |
|:-----------|:---------|:----:|:--------------------------------------------------------------------------------------|
| `user_id`  | `string` |  x   | Matrix user ID of the Matrix user this source previously used to publish information. |
| `event_id` | `string` |  x   | ID of the latest event published by the source using its previous user.               |

Each time one of the source's properties changes, it **must** publish a new
registration event, and every trust authority certifying the trustworthiness of
this source **must** generate a new signature from the new event. This signature
lives in a TA's registration event 📝.

If a source doesn't provide a logo, client implementations **can** use the
[avatar](https://matrix.org/docs/spec/client_server/r0.4.0.html#get-matrix-client-r0-profile-userid-avatar-url)
of its Matrix user instead.

## Compromission of cryptographic private keys

Every trust authority certifying a source's trustworthiness **must** be operated
by an organism or individual the source trusts and is in contact with outside of
Informo. If at least one of a source's private keys gets compromised, the source
**must** update its list of public signature verification keys by publishing a
new registration event containing the updated list, and every trust authority
trusting the source **must** compute and issue a new signature taking the
updated list of keys into account. The reason behind this is to encourage trust
authorities to communicate with their trusted sources, estimate how much
compromised the source is (i.e. one key vs all of the keys vs the source's
entire Matrix account), and take the actions it deems necessary.

In such an event, client implementations **should** consider articles posted
prior to the key being declared as compromised as probably not having been
tampered with, with no way to be 100% sure about it.

## Change of Matrix user

A source or sub-source might have to change the Matrix user it uses to publish
information at some points in its life time. This can happen for many reason:
the homeserver it was registered on went down, or got compromised, or got
isolated from the rest of the federation...

In such an event, the source or sub-source **must** publish a new registration
event from its new Matrix user with the `prev_user` key set. The value of this
key **must** be a map in which the `user_id` key's value is the source's or
sub-source's previous user's, and the `event_id` key's value is the ID of the
latest event emitted prior to the change.

This key **must** be used by client implementations to link the previous user to
the new one, considering both as the same entity. A missing `prev_user` key
simply means that the source or sub-source didn't previously use another Matrix
account to publish information.

If the entity is a source (and not a sub-source), trust authorities certifying
it as trustworthy **must** update their list of trusted entities by removing the
previous user from it, and adding the new one to it. The signature associated
with the new user **must** be generated from the new user's registration event.

### Linking between a source and its new user

Client implementations are in charge of asserting the vailidy of a link between
a source, or sub-source, and its new user, using whatever mechanism they see
fit.

{{% notice tip %}}
A suggested way to assert the validity of this link would be for a client
implementation to define a threshold for linking a source to its new user. This
threshold is defined by the percentage of trust authorities certifying this
source as trustworthy that updated their list of trusted sources to reference
the new user, within the trust authorities trusted by the user. If a threshold
is defined by a client implementation, it should consider the link between a
source and its new user as valid once that percentage becomes higher than the
threshold. Such a threshold wouldn't be necessary for sub-sources, because a
sub-source is only verified by its parent source, which then needs to update its
list of sub-sources by removing the sub-source's previous user and adding the
new one.
{{% /notice %}}

Once the link between a source (or a sub-source) and its new user is considered
valid, client implementations **must** consider both the source's (or
sub-source's) new user and its previous one (and older ones if the source or
sub-source changed its user more than once) as the same entity (i.e. as an
entity defined by both its previous users' IDs and its new one). This means that
articles published by the source's (or the sub-source's) previous user before
the event defined in the `event_id` key **must** be treated as if it was
published by the new user, and a reference to the source's previous user in a
trust authority's list of trustworthy sources **must** be considered as a
reference to the new user (with the exception of the cryptographic check on the
source's registration, which is still done using the registration event
published by the previous user, and the previous user's Matrix user ID).

Client implementations **can** warn users reading articles published by a
source's or a sub-source's previous user that this user isn't active anymore,
and might get compromised at some point. This is the only exception to the equal
treatment principle mentioned in the previous paragraph.

{{% notice tip %}}
If a trust authority certifying the source or subsource that's changing its
Matrix user as trustworthy deems it necessary, it can also add the source's (or
sub-source's) previous user to its blacklist, as documented [in the related
section]({{< ref "/trust-management/trust-authority#blacklisting" >}}).
{{% /notice %}}

## Localisation

An information website might want to publish articles in more than one language.
In such case, it **can** create sub-sources, each of which handling the
publication of its articles in one language. A source, regardless of whether it
is a sub-source or not, **must not** publish articles in more than one language.

A sub-source is an entity similar to a source, with the exception that it
**must** be referenced to by a source. Each sub-source **must** be a registered
Matrix user, and **must** register itself on the Matrix room through the
publication of a `network.informo.subsource` state event, with the Matrix user's
ID as the event's state key. The event's content **must** be embedded in a
[signed Matrix event](/information-distribution/signature/#signed-matrix-event),
signed by one of the parent source's public keys, with its `signed` object using
the following model:

### Matrix event `network.informo.subsource`

| Parameter     | Type       | Req. | Description                                                                                                                                                                                                  |
|:--------------|:-----------|:----:|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `parent`      | `string`   |  x   | Matrix user ID of the sub-source's parent.                                                                                                                                                                   |
| `sig_algo`    | `string`   |  x   | Algorithm the sub-source will use to cryptographically sign its articles. 🔧                                                                                                                                 |
| `sig_keys`    | `[string]` |  x   | Public keys the sub-source will use to cryptographically sign its articles. 🔧                                                                                                                               |
| `prev_user`   | `prevUser` |      | Matrix user the sub-source previously used to publish information. See [above](#change-of-matrix-user) for additional information on how a source can change the Matrix user it uses to publish information. |
| `website`     | `string`   |      | URL of the source's website in this language, if there's one.                                                                                                                                                |
| `description` | `string`   |      | Short localised description of the source and its publications.                                                                                                                                              |
| `custom`      | `object`   |      | Additional information for custom client implementations.                                                                                                                                                    |

The parent source **must** then reference the sub-source in its own registration
event, as a `lang` object. The `lang` object **can** reference the source that
emitted the `network.informo.source` event, but a Matrix user ID **must not** be
referenced more than once in a source registration's `lang` object.

{{% notice info %}}
A source **can** register itself as one if its own sub-sources. In this case, it
doesn't need to emit any `network.informo.subsource` event for this specific
sub-source. The articles published by the source acting as one of its
sub-sources **must** be signed using one of the source's public keys.
{{% /notice %}}

If set, client implementations **must** use the value for the `description` and
`website` keys of the `network.informo.subsource` event instead of the localised
description and the website provided in the parent source's
`network.informo.source` event.

Client implementations **must** consider a sub-source as holding the same [trust
level](/trust-management/trust-level) as its parent source, and therefore
**must** consider it at the same location in trust networks as its parent.

### Example

Let's consider the example of an example website publishing news only in
English, and registering itself as a source with the Matrix user id
`@acmenews:example.com`, and not registering any sub-source, the `lang` object
would look like this:

```
{
    "en": "@acmenews:example.com"
}
```

{{% notice tip %}}
In this example, `en-US`, `en-GB`, etc. can be used instead of `en` if the
source wants to explicitely specify language variants.
{{% /notice %}}

## Client implementations behaviours regarding sources

Client implementations **should** allow users to subscribe to all of the
articles published by a specific source.

client implementations **can** display a source and all of its sub-sources as a
single entity with several languages available.

client implementations **should** allow users to set at least one preferred
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
Matrix](https://matrix.org/docs/projects/try-matrix-now.html#client-sdks).
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
    "sig_algo": "ed25519",
    "sig_keys": [
        "IlRMeOPX2e0MurIyfWEucYBRVOEEUMrOHqn/8mLqMjA"
    ],
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
    "algorithm": "ed25519",
    "sender_key": "IlRMeOPX2e0MurIyfWEucYBRVOEEUMrOHqn/8mLqMjA",
    "signature": "54ab6f6f18d63ef1",
    "signed": {
        "parent": "@acmenews:example.com",
        "prev_user": {
            "user_id": "@acmenewsen:badserver.com",
            "event_id": "!someEnglishArticle:badserver.com",
        },
        "website": "https://www.example.com/en",
        "description": "This is the English source for ACME News.",
        "sig_algo": "ed25519",
        "sig_keys": [
            "Noh0oot2chahTheixeuviX6seidiweewahK/8mLeMjA"
        ]
    }
}
```

#### `network.informo.subsource` event

| Emitter                   | State key                 |
|:--------------------------|:--------------------------|
| `@acmenewsfr:example.com` | `@acmenewsfr:example.com` |

```json
{
    "algorithm": "ed25519",
    "sender_key": "IlRMeOPX2e0MurIyfWEucYBRVOEEUMrOHqn/8mLqMjA",
    "signature": "0a1df56f18d63ef1",
    "signed": {
        "parent": "@acmenews:example.com",
        "prev_user" : {
            "user_id": "@acmenewsfr:badserver.com",
            "event_id": "!someFrenchArticle:badserver.com",
        },
        "website": "https://www.example.com/fr",
        "description": "Ceci est la source française d'ACME News.",
        "sig_algo": "ed25519",
        "sig_keys": [
            "xee1PahM1jutohz2jiec1keeshoW0GooVei/8mLeMjA"
        ]
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
    "sig_algo": "ed25519",
    "sig_keys": [
        "IlRMeOPX2e0MurIyfWEucYBRVOEEUMrOHqn/8mLqMjA"
    ],
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
    "algorithm": "ed25519",
    "sender_key": "IlRMeOPX2e0MurIyfWEucYBRVOEEUMrOHqn/8mLqMjA",
    "signature": "0a1df56f18d63ef1",
    "signed": {
        "parent": "@acmenews:example.com",
        "website": "https://www.example.com/fr",
        "description": "Ceci est la source française d'ACME News.",
        "sig_algo": "ed25519",
        "sig_keys": [
            "xee1PahM1jutohz2jiec1keeshoW0GooVei/8mLeMjA"
        ]
    }
}
```

Once both of these events have been published, `@acmenews:example.com` can
start publishing articles in English, and `@acmenewsfr:example.com` can start
publishing articles in French.
