---
title: "Trust authority"
weight: 1
---

One key entity in Informo's trust management mechanisms is called "trust
authorities", often also referred as "TA". As defined in [this documentation's
terminology]({{<ref "/introduction/terminology#trust-authority-ta">}}), a trust
authority is an entity that asserts the trustworthiness of another entity,
whether this entity is an information source or another trust authority. It does
so by using asymmetric cryptographic signatures.

A user **must** be able to chose which TA they trust, whether that TA is itself
trusted by another TA or not. This model follows the outlines of [Delegative
Democracy](https://en.wikipedia.org/wiki/Delegative_democracy), as it allows a
user to either trust a source based on their own research and criteria, or
delegate the assertion of a source's trustworthiness to another party.

A trust authority's main responsibility is to assert the trustworthiness of a
source or of another TA. This means that the TA **must** publish a list of all
of the sources and TAs it trusts, keep it up to date, and give the information
needed to certify the sources' and TAs' authenticity.

If a user chooses to trust a specific TA, let's name it *SomeNGO.org* here for
the sake of simplicity, all sources and TAs trusted by *SomeNGO.org* **must** be
considered as trustworthy by client implementations in accordance with their
chosen trust level (documented in [the related
section]({{<ref "/trust-management/trust-level">}})).

A trust authority **can** specify a reason for trusting another TA or a source.
If specified, this reason **must** consist in a custom localised string provided
in by the trust authority.

## Trust authority registration

A trust authority **must** register itself as such on the Matrix room. This
registration **must** be done through the publication of a
`network.informo.trust_authority` state event. The event's state key **must** be
the ID of the trust authority's current Matrix user, and its content **must**
include data on the individual or organisation operating the TA, along with the
list of its public signature verification keys and the list of all of the
sources and trust authorities it trusts. This list **must** include, for each
trusted source and TA, a signature generated from their registration event's
content by using one of the TA's public keys, as described below.

#### Matrix event `network.informo.trust_authority`

| Parameter     | Type               | Req. | Description                                                                                                                                                                                                                                              |
|:--------------|:-------------------|:----:|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `name`        | `LocalisedString`  |  x   | Name of the trust authority.                                                                                                                                                                                                                             |
| `sig_keys`    | `Keys`             |  x   | Public keys the trust authority will use to generate cryptographic signatures.                                                                                                                                                                           |
| `prev_user`   | `PrevUser`         |      | Matrix user the trust authority previously used to verify or blacklist entities. See [below]({{<ref "#change-of-matrix-user">}}) for additional information on how a trust authority can change the Matrix user it uses to verify or blacklist entities. |
| `website`     | `string`           |      | URL of the trust authority's website, if there's one.                                                                                                                                                                                                    |
| `description` | `LocalisedString`  |      | Short description of the trust authority and its publications.                                                                                                                                                                                           |
| `logo`        | `string`           |      | Logo of the trust authority. If provided, **must** be a [`mxc://` URL](https://matrix.org/docs/spec/client_server/r0.4.0.html#id112).                                                                                                                    |
| `country`     | `string`           |      | Country of the trust authority's owner. If provided, **must** be compliant with [ISO 3166](https://www.iso.org/iso-3166-country-codes.html).                                                                                                             |
| `trusted`     | `TrustedEntities`  |      | Entities (sources and other trust authorities) trusted by the trust authority.                                                                                                                                                                           |
| `blacklist`   | `BlacklistEntries` |      | Entities (sources and other trust authorities) and nodes blacklisted by the trust authority.                                                                                                                                                             |
| `custom`      | `object`           |      | Additional information for custom client implementations.                                                                                                                                                                                                |

Where:

<!--
    The definitions of `LocalisedString`, `Keys` and `PrevUser` here are the
    same as in source.nd.md. People changing any (or all of them) might want to
    also change it there (or remove this warning).
-->
* `LocalisedString` is a map associating a [RFC
  5646](https://tools.ietf.org/html/rfc5646)-compliant language (and variant)
  identifier to a localisation of the string in the language the identifier
  refers to.
* `Keys` is a map associating a public key to the algorithm used in order to
  generate a signature with this key.
* `PrevUser` is a map using the following structure:

| Parameter   | Type     | Req. | Description                                                                                                                                                                                                                                                                                                            |
|:------------|:---------|:----:|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `user_id`   | `string` |  x   | ID of the Matrix user this trust authority previously used to verify or blacklist entities.                                                                                                                                                                                                                            |
| `event_id`  | `string` |  x   | ID of the latest event published by the trust authority's original administrator using the trust authority's previous user.                                                                                                                                                                                            |
| `sig_algo`  | `string` |      | Algorithm used to generate `signature`.                                                                                                                                                                                                                                                                                |
| `sig_key`   | `string` |      | Public key to use when verifying `signature`. **Should** be one of the trust authority's previous user's public keys.                                                                                                                                                                                                  |
| `signature` | `string` |      | Signature generated from a `PrevUserSign` map derived from the current `PrevUser` map, using the key specified in `sig_key` and the algorithm specified in `sig_algo`, and following the instructions described [here]({{<ref "/information-distribution/signature#signing-json-data">}}) (under "Signing JSON data"). |

* `PrevUserSign` is a map using the following structure:

| Parameter       | Type     | Req. | Description                                                                                                                                                                              |
|:----------------|:---------|:----:|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `prev_user_id`  | `string` |  x   | ID of the Matrix user this trust authority previously used to verify or blacklist entities. **Must** match the `user_id` of the current `prevUser` map.                                  |
| `prev_event_id` | `string` |  x   | ID of the latest event published by the trust authority's original administrator using the trust authority's previous user. **Must** match the `event_id` of the current `PrevUser` map. |
| `new_user_id`   | `string` |  x   | ID of the Matrix user this trust authority currently uses to verify or blacklist entities. **Must** match the ID of the new user in use by the trust authority.                          |

* `TrustedEntities` is a map using the following structure:

| Parameter           | Type             | Req. | Description                     |
|:--------------------|:-----------------|:----:|:--------------------------------|
| `sources`           | `TrustedSources` |      | The sources trusted by this TA. |
| `trust_authorities` | `TrustedTAs`     |      | The TAs trusted by this TA.     |
| `nodes`             | `TrustedNodes`   |      | The nodes trusted by this TA.   |

* `TrustedSources` is a map associating a Matrix user ID to a map that uses the
  following structure:

| Parameter   | Type              | Req. | Description                                                                                                                            |
|:------------|:------------------|:----:|:---------------------------------------------------------------------------------------------------------------------------------------|
| `signature` | `string`          |  x   | Signature generated from a `SignedObject`, containing the entity's registration event, using one of the trust authority's public keys. |
| `reason`    | `LocalisedString` |      | Reason given by the TA explaining why they trust this source.                                                                          |

* `TrustedTAs` is a map associating a Matrix user ID to a JSON object using the
  following structure:

| Parameter   | Type              | Req. | Description                                                                                                                                                                                                                                                                            |
|:------------|:------------------|:----:|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `signature` | `string`          |  x   | Signature generated from a `SignedObject`, containing the entity's registration event, using one of the trust authority's public keys, and following the instructions described [here]({{<ref "/information-distribution/signature#signing-json-data">}}) (under "Signing JSON data"). |
| `level`     | `integer`         |      | The trust level the TA trusts the entity with.                                                                                                                                                                                                                                         |
| `reason`    | `LocalisedString` |      | Reason given by the TA explaining why they trust this other TA.                                                                                                                                                                                                                        |

* `SignedObject` is a map using the following structure:

| Parameter      | Type              | Req. | Description                                                                                                                                              |
|:---------------|:------------------|:----:|:---------------------------------------------------------------------------------------------------------------------------------------------------------|
| `registration` | `object`          |  x   | The content of latest version of the entity's registration event.                                                                                        |
| `level`        | `integer`         |      | The level the TA trusts the entity with. This value **must** match the level provided alongside the signature. Only valid when the entity is another TA. |
| `reason`       | `LocalisedString` |      | Reason given by the TA explaining why they trust this entity. This value **must** match the reason provided alongside the signature.                     |

* `TrustedNodes` is a map associating a node's server name (as a string) to a
  map using the following structure:

| Parameter   | Type              | Req. | Description                                                                                                                                                                                                                                           |
|:------------|:------------------|:----:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `signature` | `string`          |  x   | Signature generated from a `SignedNodeObject`, containing the node's server name, using one of the trust authority's public keys, and following the instructions described [here]({{<ref "/information-distribution/signature#signing-json-data">}}). |
| `reason`    | `LocalisedString` |      | Reason given by the TA explaining why they trust this node.                                                                                                                                                                                           |

* `SignedNodeObject` is a map using the following structure:

| Parameter    | Type              | Req. | Description                                                                                                                        |
|:-------------|:------------------|:----:|:-----------------------------------------------------------------------------------------------------------------------------------|
| `serverName` | `string`          |  x   | The node's server name.                                                                                                            |
| `reason`     | `LocalisedString` |      | Reason given by the TA explaining why they trust this node. This value **must** match the reason provided alongside the signature. |

* `BlacklistEntries` is a map using the following structure:

| Parameter  | Type                  | Req. | Description                                                                        |
|:-----------|:----------------------|:-----|:-----------------------------------------------------------------------------------|
| `entities` | `BlacklistedEntities` |      | Entities (sources and other trust authorities) blacklisted by the trust authority. |
| `nodes`    | `BlacklistedNodes`    |      | Nodes blacklisted by the trust authority.                                          |

* `BlacklistedEntities` is a map associating a Matrix user ID to a
  `BlacklistEntry`.

* `BlacklistedNodes` is a map associating a node's server name (as a string) to
  a `BlacklistEntry`.

* `BlacklistEntry` is a map using the following structure:

| Parameter     | Type              | Req. | Description                                                                                                                     |
|:--------------|:------------------|:----:|:--------------------------------------------------------------------------------------------------------------------------------|
| `reason_code` | `string`          |  x   | One of the reason codes defined [below]({{<ref "#blacklist-reason-codes">}}).                                                   |
| `after`       | `string`          |      | ID of the latest trustworthy event sent by the entry's target. Empty string or omit key if none (e.g. with `B_DISINFORMATION`). |
| `reason`      | `LocalisedString` |      | More information on the reason the TA blacklisted the entry's target for.                                                       |

#### Example

```json
{
    "name": {
        "en": "Some NGO",
        "fr": "Une ONG"
    },
    "sig_keys": {
        "IlRMeOPX2e0MurIyfWEucYBRVOEEUMrOHqn/8mLqMjA": "ed25519"
    },
    "prev_user": {
        "user_id": "@somengo:badserver.com",
        "event_id": "!someEnglishArticle:badserver.com",
		"sig_algo": "ed25519",
		"sig_key": "IlRMeOPX2e0MurIyfWEucYBRVOEEUMrOHqn/8mLqMjA",
		"signature": "quanaijoumae3Fi",
    },
    "website": "https://www.somengo.org",
    "description": {
        "en": "We do activism for freedom of the press.",
        "fr": "Nous sommes des activistes en faveur de la liberté de la presse."
    },
    "logo": "mxc://weu.informo.network/AtEuTuVSeIlZQgjEzjGyMDtG",
	"country": "FR",
    "trusted": {
        "sources": {
            "@acmenews:example.com": {
                "signature": "0a1df56f1c3ab5b"
            }
        },
        "trust_authorities": {
            "@someotherngo:example2.com": {
                "signature": "daiRanaiy1be7pe",
                "level": 2
            }
        },
        "nodes": {
            "somengo.org": {
                "signature": "UingeeJahkog5oh",
            }
        }
    },
    "blacklist": {
        "entities": {
            "@sadsource:example.com": {
                "reason_code": "B_COMPROMISED",
                "after": "!someEvent:example.com"
            },
            "@badsource:example.com": {
                "reason_code": "B_DISINFORMATION",
                "reason": {
                    "en": "This source actually belongs to the Tomainian government which uses it for propaganda.",
                    "fr": "Cette source appartient au gouvernement Tomanien qui l'utilise à des fins de propagande."
                }
            }
        },
        "nodes": {
            "badserver.com": {
                "reason_code": "B_COMPROMISED",
                "after": "!someOtherEvent:example.com"
            }
        }
    }
}
```

## Blacklisting

A trust authority **can** list nodes, sources and trust authorities that it
explicitly blacklists for being compromised or ethical reasons. The trust
authority **must** specify a reason for blacklisting a node, source or TA, which
consists in a defined reason code that client implementations **should** use in
order to warn users about a specific Matrix user (representing either a source
or another TA), or Matrix users belonging to a given node. The trust authority
**can** also provide additional information to explain the addition to the
blacklist, which, if provided, **must** take the form of a custom localised
string. Client implementations **should** also use this string to provide the
users with more information on why a specific source was blacklisted, either
directly or indirectly, by the trust authority.

### Blacklist reason codes

As mentioned above, a trust authority **must** provide a reason for blacklisting
a node, a source or another trust authority. This **must** be done using at
least a reason code, which **must** be one of the following:

#### `B_COMPROMISED`

This code can have different meaning depending on the target:

| Target's type                     | Meaning                                                                                                                                                                                           |
|:----------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Source** or **trust authority** | One of the public keys or the Matrix user of the source or trust authority has been compromised.                                                                                                  |
| **Node**                          | The node is managed or has been taken over by people trying to harm the federation, impersonate other news sources or taking over Matrix accounts that were previously considered as trustworthy. |



#### `B_DISINFORMATION`

This code can have different meaning depending on the target:

| Target's type       | Meaning                                                                                                                                                           |
|:--------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Source**          | The source has been publishing false or unverified information intentionnally.                                                                                    |
| **Trust authority** | The trust authority has been certifying sources publishing false or unverified information as trustworthy intentionnally.                                         |
| **Node**            | The node exists in the sole purpose of hosting sources or trust authorities that either post unreliable information or certify deceptive entities as trustworthy. |

#### `B_ABANDONED`

This code means that the target has ceased its activity and/or to publish
articles through this federation, therefore the entity isn't used anymore and
very unlikely to ever be used again. Blacklisting it then prevents someone else
from getting their hands on the target (through its keys and access tokens if
the target is a source or TA, or by taking over the node's server name if the
target is a node) and impersonating affected sources and/or trust authorities.

## Suggested trust authorities

In order to guide a new user through building his trusted network when they
enter a federation, the federation's administrator **can** provide a list of
suggested TAs through the publication of a
`network.informo.suggested_trust_authorities` state event. The event's state key
**must** be an empty string. The federation's [power
levels](https://matrix.org/docs/spec/client_server/r0.4.0.html#m-room-power-levels)
for publishing this event **must** be set to a non-zero value. The event's
content **must** use the following structure:

### Matrix event `network.informo.suggested_trust_authorities`

| Parameter           | Type       | Req. | Description                                         |
|:--------------------|:-----------|:----:|:----------------------------------------------------|
| `trust_authorities` | `[string]` |  x   | Matrix user IDs of the suggested trust authorities. |

Client implementations **can** use this list of trust authorities to suggest TAs
to trust to users who don't know which TA they should trust first.

As an additional security step, client implementations maintainers **should**
add the suggested trust authorities' public keys to the implementation's code
base for at least one federation, so the user doesn't retrieve these keys
through a potentially insecure network. This is an important step because these
TAs are likely to represent the foundations of the user's trust network.

In the event of an embedded public key getting compromised or removed from their
set of keys in use, trust authorities **must** make implementation maintainers
aware of it, either directly or through an administrator of the Matrix room, in
a reliable way independent from Informo, and implementation maintainers **must**
release a new version of their implementation which **must not** include the
compromised key.

In the event of a suggested trust authority changing its Matrix user, the
federation administrators **must** update the
`network.informo.suggested_trust_authorities` event with the new Matrix user ID.
The trust authority **should** get in thouch with the federation's
administrators in a reliable way independent from Informo to let them know about
the change.

### Example

```json
{
    "trust_authorities": [
        "@somengo:example.com",
        "@someotherngo:someotherngo.org"
    ]
}
```

## Change of Matrix user

A trust authority might have to change the Matrix user it uses to verify or
blacklist entities at some points in its life time. This can happen for many
reasons: the homeserver it was registered on went down, or got compromised, or
got isolated from the rest of the federation...

In such an event, a trust authority **can** follow the same procedure as with
sources and sub-sources specified [here]({{< ref
"/information-distribution/source#change-of-matrix-user" >}}). Client
implementations **must** then follow the same procedure as they would with a
source or a sub-source in a similar situation.

## Cryptographic private keys getting compromised

In the event of a trust authority having one or more of its cryptographic
private keys compromised, it **must** get in touch with every trust authority
certifying it as trustworthy and follow the same instructions as if it was a
source ([described here]({{<relref
"/information-distribution/source#cryptographic-private-keys-getting-compromised">}})).
Client implementations **must** also take the same considerations regarding
articles published by the sources the TA certifies as trustworthy (either
directly or indirectly) as described in that same section.

In such an event, the compromised trust authority **must** publish new
signatures for the sources and trust authorities it certifies as trustworthy,
generated with a non-compromised key (either a new one, or an existing one that
hasn't been compromised yet).

## Client implementations

In the event of a source being trusted by a TA `A` and blacklisted by a TA `B`,
given that both `A` and `B` are being trusted by the user, client
implementations **should** display a warning to users, indicating that, although
some of the user's trusted TAs are still asserting the source as being
trustworthy, some others explicitly stated that the source should not be trusted
anymore, mentioning the reasons specified in the corresponding blacklist entry.

In order to help its users assert the trustworthiness of a source, a client
implementation **might** include the display of a graph showing the location of
the source in the federation's trust network. It **might** also include a view
promoting sources that have been certified as trustworthy by several TAs that
the user trusts.

Client implementations **must** consider a node being blacklisted by a TA as if
all of the entities belonging to that node were blacklisted by this TA for the
same reason and from the same point in time (if specified). If a TA blacklists
an entity belonging to a node that's already blacklisted, client implementations
**must** use the entity's blacklist entry rather than the node's.
