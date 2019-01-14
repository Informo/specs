---
title: "Trust authority"
weight: 1
---

One key party of Informo's trust management mechanisms is called "trust
authorities", often also referred as "TA". As defined in [this documentation's
terminology](/introduction/terminology/#trust-authority-ta), a trust authority
is an entity that asserts the trustworthiness of another entity, whether this
entity is an information source or another trust authority. It does so by using
asymmetric cryptographic signatures.

A user **must** be able to chose which TA they want to give their absolute trust
to, whether that TA is itself trusted by another TA or not. This model follows
the outlines of [Delegative
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
section](/trust-management/trust-level/)).

A trust authority **can** specify a reason for trusting another TA or a source.
If specified, this reason **must** consist in a custom localised string provided
in by the trust authority.

## Trust authority registration

A trust authority **must** register itself as such on the Matrix room. This
registration **must** be done through the publication of a
`network.informo.trust_authority` state event. The event's state key **must** be
the ID of the trust authority's Matrix user, and its content **must** include
data on the organism operating the TA, along with the list of its public
signature verification keys and the list of all of the sources and trust
authorities it trusts. This list **must** include, for each trusted source and
TA, a signature generated from their registration event content by using one of
the TA's public keys, as described below.

A TA's registration **must** associate each signature with the identifier of the
trusted source or TA, and with the signing algorithm used to generate it
(`ed25519`, `hmac-sha256`, `hmac-sha512`, etc.).

In the event of one of a TA's private keys being compromised, it **must** update
its list of public signature verification keys by removing the compromised key
(and adding one new key or more to the said list), and the other trust
authorities trusting this TA **must** compute and issue a new signature taking
the updated list of keys into account.

#### Matrix event `network.informo.trust_authority`

| Parameter     | Type               | Req. | Description                                                                                                                                  |
|:--------------|:-------------------|:----:|:---------------------------------------------------------------------------------------------------------------------------------------------|
| `name`        | `localisedString`  |  x   | Name of the trust authority.                                                                                                                 |
| `sig_algo`    | `string`           |  x   | Algorithm the trust authority will use to generate cryptographic signatures. 🔧                                                              |
| `sig_keys`    | `[string]`         |  x   | Public keys the trust authority will use to generate cryptographic signatures. 🔧                                                            |
| `website`     | `string`           |      | URL of the trust authority's website, if there's one.                                                                                        |
| `description` | `localisedString`  |      | Short description of the trust authority and its publications.                                                                               |
| `logo`        | `string`           |      | Logo of the trust authority. If provided, must be a [`mxc://` URL](https://matrix.org/docs/spec/client_server/r0.4.0.html#id112).            |
| `country`     | `string`           |      | Country of the trust authority's owner. If provided, **must** be compliant with [ISO 3166](https://www.iso.org/iso-3166-country-codes.html). |
| `trusted`     | `trustedEntities`  |      | Entities (sources and other trust authorities) trusted by the trust authority.                                                               |
| `blacklist`   | `blacklistEntries` |      | Entities (sources and other trust authorities) and nodes blacklisted by the trust authority.                                                 |
| `custom`      | `object`           |      | Additional information for custom client implementations.                                                                                    |

<!-- 🔧: Need to do some research on Megolm and Matrix APIs around encryption
and key management -->

Where:

<!--
   The definition of `localisedString` here is the same as in source.md.
   People changing it might want to also change it there (or remove this
   warning).
-->
* `localisedString` is a map associating a [RFC
  5646](https://tools.ietf.org/html/rfc5646)-compliant language (and variant)
  identifier to a localisation of the string in the language the identifier
  refers to.
* `trustedEntities` is a map using the following structure:

| Parameter           | Type             | Req. | Description                     |
|:--------------------|:-----------------|:----:|:--------------------------------|
| `sources`           | `trustedSources` |      | The sources trusted by this TA. |
| `trust_authorities` | `trustedTAs`     |      | The TAs trusted by this TA.     |
| `nodes`             | `trustedNodes`   |      | The nodes trusted by this TA.   |

* `trustedSources` is a map associating a Matrix user ID to a JSON object using
  the following structure:

| Parameter   | Type              | Req. | Description                                                                                                                                                                        |
|:------------|:------------------|:----:|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `signature` | `string`          |  x   | Signature generated from a `signedObject`, containing the entity's registration event, using one of the trust authority's public keys and the algorithm provided under `sig_algo`. |
| `reason`    | `localisedString` |      | Reason given by the TA explaining why they trust this source or other TA.                                                                                                          |

* `trustedTAs` is a map associating a Matrix user ID to a JSON object using the
  following structure:

| Parameter   | Type              | Req. | Description                                                                                                                                                                                                                                                                                 |
|:------------|:------------------|:----:|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `signature` | `string`          |  x   | Signature generated from a `signedObject`, containing the entity's registration event, using one of the trust authority's public keys and the algorithm provided under `sig_algo`, and following the instructions described [here](/information-distribution/signature/#signing-json-data). |
| `level`     | `integer`         |      | The trust level the TA trusts the entity with.                                                                                                                                                                                                                                              |
| `reason`    | `localisedString` |      | Reason given by the TA explaining why they trust this source or other TA.                                                                                                                                                                                                                   |

* `signedObject` is a map using the following structure:

| Parameter      | Type              | Req. | Description                                                                                                                                              |
|:---------------|:------------------|:----:|:---------------------------------------------------------------------------------------------------------------------------------------------------------|
| `registration` | `object`          |  x   | The content of latest version of the entity's registration event.                                                                                        |
| `level`        | `integer`         |      | The level the TA trusts the entity with. This value **must** match the level provided alongside the signature. Only valid when the entity is another TA. |
| `reason`       | `localisedString` |      | Reason given by the TA explaining why they trust this entity. This value **must** match the reason provided alongside the signature.                     |

* `trustedNodes` is a map associating a node's server name (as a string) to a
  JSON object using the following structure:

| Parameter   | Type              | Req. | Description                                                                                                                                                                                                                                                                            |
|:------------|:------------------|:----:|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `signature` | `string`          |  x   | Signature generated from a `signedNodeObject`, containing the node's server name, using one of the trust authority's public keys and the algorithm provided under `sig_algo`, and following the instructions described [here](/information-distribution/signature/#signing-json-data). |
| `reason`    | `localisedString` |      | Reason given by the TA explaining why they trust this node.                                                                                                                                                                                                                            |

* `signedNodeObject` is a map using the following structure:

| Parameter    | Type              | Req. | Description                                                                                                                        |
|:-------------|:------------------|:----:|:-----------------------------------------------------------------------------------------------------------------------------------|
| `serverName` | `string`          |  x   | The node's server name.                                                                                                            |
| `reason`     | `localisedString` |      | Reason given by the TA explaining why they trust this node. This value **must** match the reason provided alongside the signature. |

* `blacklistEntries` is a map using the following structure:

| Parameter  | Type                  | Req. | Description                                                                        |
|:-----------|:----------------------|:-----|:-----------------------------------------------------------------------------------|
| `entities` | `blacklistedEntities` |      | Entities (sources and other trust authorities) blacklisted by the trust authority. |
| `nodes`    | `blacklistedNodes`    |      | Nodes blacklisted by the trust authority.                                          |

* `blacklistedEntities` is a map associating a Matrix user ID to a
  `blacklistEntry`.

* `blacklistedNodes` is a map associating a node's server name (as a string) to
  a `blacklistEntry`.

* `blacklistEntry` is a map using the following structure:

| Parameter     | Type              | Req. | Description                                                                                                                     |
|:--------------|:------------------|:----:|:--------------------------------------------------------------------------------------------------------------------------------|
| `reason_code` | `string`          |  x   | One of the reason codes defined [above](#blacklist-reason-codes).                                                               |
| `after`       | `string`          |      | ID of the latest trustworthy event sent by the entry's target. Empty string or omit key if none (e.g. with `B_MISINFORMATION`). |
| `reason`      | `localisedString` |      | More information on the reason the TA blacklisted the entry's target for.                                                       |

#### Example

```json
{
    "name": {
        "en": "Some NGO",
        "fr": "Une ONG"
    },
    "sig_algo": "ed25519",
    "sig_keys": [
        "IlRMeOPX2e0MurIyfWEucYBRVOEEUMrOHqn/8mLqMjA"
    ],
    "website": "https://www.somengo.org",
    "description": {
        "en": "We do activism for freedom of the press.",
        "fr": "Nous sommes des activistes en faveur de la liberté de la presse."
    },
    "logo": "mxc://weu.informo.network/AtEuTuVSeIlZQgjEzjGyMDtG",
    "trusted": {
        "sources": {
            "@acmenews:example.com": {
                "signature": "0a1df56f1c3ab5b1"
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
                "reason_code": "B_MISINFORMATION",
                "additional_info": {
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
directly or indirectly by the trust authority.

### Blacklist reason codes

As defined above, a trust authority **must** provide a reason for blacklisting a
node, a source or another trust authority. This **must** be done using at least
a reason code, which **must** be one of the following:

#### `B_COMPROMISED`

This code can have different meaning depending on the target:

| Target type                       | Meaning                                                                                                                                                                                           |
|:----------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Source** or **trust authority** | One of the public keys or the Matrix user of the source or trust authority has been compromised.                                                                                                  |
| **Node**                          | The node is managed or has been taken over by people trying to harm the federation, impersonate other news sources or taking over Matrix accounts that were previously considered as trustworthy. |



#### `B_MISINFORMATION`

This code can have different meaning depending on the target:

| Target type         | Meaning                                                                                                                                             |
|:--------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------|
| **Source**          | The source has been publishing false or unverified information intentionnally.                                                                      |
| **Trust authority** | The trust authority has been certifying sources publishing false or unverified information as trustworthy intentionnally.                           |
| **Node**            | The node exists in the sole purpose of registering sources or trust authority that either post unreliable information or certify it as trustworthy. |

#### `B_ABANDONED`

This code means that the target has ceased its activity and/or to publish articles through this federation, therefore the entity isn't used anymore and very unlikely to ever be used again. Blacklisting it then prevents someone else from getting their hands on the target (through its keys and access tokens if the target is a source or TA, or by taking over the node's server name if the target is a node) and impersonating affected sources and/or trust authorities.

## Suggested trust authorities

In order to guide a new user through building his trusted network when they
enter a Matrix room (i.e. an Informo federation), the room's administrator
**can** provide a list of suggested TAs through the publication of a
`network.informo.suggested_trust_authorities` state event. The event's state key
**must** be an empty string. The Matrix room's [power
levels](https://matrix.org/docs/spec/client_server/r0.4.0.html#m-room-power-levels)
**must** be set to a non-zero value. The event's content **must** use the
following structure:

| Parameter           | Type       | Req. | Description                                         |
|:--------------------|:-----------|:----:|:----------------------------------------------------|
| `trust_authorities` | `[string]` |  x   | Matrix user IDs of the suggested trust authorities. |

Client implementations **can** use this list of trust authorities to suggest TAs
to trust to users who don't know which TA they should trust first.

As an additional security step, client implementations maintainers **should**
add the suggested trust authorities' public signature verification keys to the
implementation's code base, so the user doesn't retrieve these keys through a
potentially insecure network. This is an important step because these TAs are
likely to represent the foundations of the user's trust network. In the event of
an embedded public key getting compromised, trust authorities **must** make
implementation maintainers aware of it, either directly or via an administrator
of the Matrix room, in a reliable way outside of Informo, and implementation
maintainers **must** release a new version of their implementation which **must
not** include the compromised key.

### Example

```json
{
    "trust_authorities": [
        "@somengo:example.com",
        "@someotherngo:someotherngo.org"
    ]
}
```

## Client implementations

In the event of a source being trusted by a TA *A* and blacklisted by a TA *B*,
given that both *A* and *B* are being trusted by the user, client
implementations **should** display a warning to users, indicating that, although
some of the user's trusted TAs are still asserting the source as being
trustworthy, some others explicitly stated that the source should not be trusted
anymore, mentioning the reasons specified in the corresponding blacklist entry.

In order to help its users assert the trustworthiness of a source, a client
implementation **might** include the display of a graph showing the location of
the source in Informo's trust network. It **might** also include a view
promoting sources that have been certified as trustworthy by several TAs that
the user trusts.
