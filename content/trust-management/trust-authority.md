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

A trust authority **must** also be able to list sources and trust authorities
that it explicitly blacklists for being compromised or ethical reasons. The
trust authority **must** specify a reason for blacklisting a source or TA, which
consists in a defined reason code (2️⃣). The trust authority **can** also
provide additional information to explain the addition to the blacklist, which,
if provided, **must** be contained in a custom localised string.

### Trust authority registration

A trust authority **must** register itself as such on the Matrix room. This
registration **must** include data on the organism operating the TA, along with
the list of its public signature verification keys and the list of all of the
sources and trust authorities it trusts. This list **must** include, for each
trusted source and TA, a signature generated from one of the TA's public keys.
This signature **must** be generated from the source's Matrix event content as
described in the [Signature
section](/information-distribution/signature/#signing-json-data).

A TA's registration **must** associate each signature with the identifier of the
trusted source or TA, and with the signing algorithm used to generate it
(`ed25519`, `hmac-sha256`, `hmac-sha512`, etc.).

In the event of one of a TA's private keys being compromised, it **must** update
its list of public signature verification keys by removing the compromised key
(and adding one new key or more to the said list), and the other trust
authorities trusting this TA **must** compute and issue a new signature taking
the updated list of keys into account.

#### Matrix event `network.informo.trust_authority`

|      Parameter      |        Type       | Req. |                                                                   Description                                                                |
| ------------------- | ----------------- | :--: | -------------------------------------------------------------------------------------------------------------------------------------------- |
| `name`              | `localisedString` |  x   | Name of the trust authority.                                                                                                                 |
| `sig_algo`          | `string`          |  x   | Algorithm the trust authority will use to generate cryptographic signatures. 🔧                                                               |
| `sig_keys`          | `[string]`        |  x   | Public keys the trust authority will use to generate cryptographic signatures. 🔧                                                             |
| `website`           | `string`          |      | URL of the trust authority's website, if there's one.                                                                                        |
| `description`       | `localisedString` |      | Short description of the trust authority and its publications.                                                                               |
| `logo`              | `string`          |      | Logo of the trust authority. If provided, must be a [`mxc://` URL](https://matrix.org/docs/spec/client_server/r0.4.0.html#id112).            |
| `country`           | `string`          |      | Country of the trust authority's owner. If provided, **must** be compliant with [ISO 3166](https://www.iso.org/iso-3166-country-codes.html). |
| `trusted`           | `trustedEntities` |      | Entities (sources and other trust authorities) trusted by the trust authority.                                                               |
| `custom`            | `object`          |      | Additional information for custom client implementations.                                                                                    |

<!-- 🔧: Need to do some research on Megolm and Matrix APIs around encryption
and key management -->

Where:

<!--
   The definition of `localisedString` here is the same than in source.md.
   People changing it might want to also change it there (or remove this
   warning).
-->
* `localisedString` is a map associating a [RFC
  5646](https://tools.ietf.org/html/rfc5646)-compliant language (and variant)
  identifier to a localisation of the string in the language the identifier
  refers to.
* `trustedEntities` is a map associating a Matrix user ID to a cryptographic
  signature generated from the entity's registration event and one of the trust
  authority's public keys, using the

#### Example

```
{
   "name": "Some NGO",
   "sig_algo": "ed25519",
   "sig_keys": [
      "IlRMeOPX2e0MurIyfWEucYBRVOEEUMrOHqn/8mLqMjA"
   ],
   "website": "https://www.somengo.org",
   "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
   "logo": "mxc://weu.informo.network/AtEuTuVSeIlZQgjEzjGyMDtG",
   "trusted": {
      "@acmenews:example.com": "0a1df56f1c3ab5b1",
      "@someothersource:example2.com": "daiRanaiy1be7pe"
   }
}
```

## Suggested trust authority

In order to guide a new user through building his trusted network when they
enters a Matrix room (i.e. an Informo federation), the room's administrator
**can** provide a list of suggested TAs (2️⃣: stored in Matrix room state).
These TAs will be proposed to the users if they doesn't know which TA they
should trust first.

As an additional security step, the client implementation maintainer **should**
add the suggested trust authorities' public signature verification keys to the
implementation's code base, so the user doesn't retrieve these keys through a
potentially insecure network. This is an important step because these TAs
represent the foundations of the user's trust network. In the event of an
embedded public key getting compromised, trust authorities **must** make
implementation maintainers aware of it, and implementation maintainers **must**
release another version of their implementation which **must not** include the
compromised key.

## Client implementations

In the event of a source being trusted by a TA *A* and blacklisted by a TA *B*,
given that both *A* and *B* are being trusted by the user, client
implementations **must** display a warning to users, indicating that, although
some of the user's trusted TAs are still asserting the source as being
trustworthy, some others explicitly stated that the source should not be trusted
anymore, mentioning the reasons specified in the corresponding blacklist entry.

In order to help its users assert the trustworthiness of a source, a client
**might** include the display of a graph showing the location of the source in
Informo's trust network. It **might** also include a view promoting sources that
have been certified as trustworthy by several TAs that the user trusts.
