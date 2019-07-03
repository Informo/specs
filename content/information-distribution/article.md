---
title: "Article"
weight: 3
---

An article is a news item published by a [source]({{<ref
"/information-distribution/source">}}) to the Matrix room. It **must** include
the item's content and title. The article **can** also include optional
properties, such as the item's author, date (in milliseconds since epoch),
original URL, description, read duration, NSFW marker, etc..

The article JSON object **must** be encapsulated in a [signed Matrix
event]({{<ref "/information-distribution/signature">}}), with its signature
generated with one of the source's keys.

If the original news item contains media, these media **must** be uploaded to
the node using [Matrix's content repository
feature](https://matrix.org/docs/spec/client_server/r0.4.0.html#id112) and their
cryptographic signatures **must** be appended to the article's event. Client
implementations **must not** display media that aren't served by a node's
content repository endpoint.

## Matrix event `network.informo.article`

This message event **must** be sent and signed by a source (or a sub-source).
See the [signed Matrix event]({{<ref
"/information-distribution/signature#signed-matrix-event">}}) page for more
information.

If the sender is not a source user, the article **should** be ignored. If the
source registers itself afterwards, its previously sent articles **should**
become visible.

### Event data

| Parameter           | Type              | Req. | Description                                                                                                                                                  |
|:--------------------|:------------------|:----:|:-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `title`             | `string`          |  x   | Article's headline.                                                                                                                                          |
| `href`              | `string`          |      | URL of the article's original post (in case the article was published on an existing website before being sent over Informo).                                |
| `short_description` | `string`          |      | Short description or introduction to the article.                                                                                                            |
| `author`            | `string`          |      | Full name of the article's author (in the case of the source not being a single individual).                                                                 |
| `thumbnail`         | `string`          |      | Preview image for the article. **Must** be a [`mxc://` URL](https://matrix.org/docs/spec/client_server/r0.4.0.html#id112).                                   |
| `date`              | `int`             |      | Timestamp (in milliseconds since epoch) of the article's publication. If not provided clients **should** fall back to the Matrix event's creation timestamp. |
| `content`           | `string`          |  x   | Article HTML content. The HTML **must** be sanitized before being displayed by a client implementation.                                                      |
| `media_sigs`        | `MediaSignatures` |  !   | Cryptographic signatures of the media embedded in the article. Required if the article contains at least one medium.                                         |
| `custom`            | `object`          |      | Additional information for custom client implementations.                                                                                                    |

Where:

* `MediaSignatures` is a map associating a [`mxc://`
  URL](https://matrix.org/docs/spec/client_server/r0.4.0.html#id112) with the
  signature of the media that's been uploaded at this URL. This signature
  **must** be generated using the same algorithm and public key that were used
  to sign the article's event. If this is not the case, or the signature can't
  be verified, client implementations **must not** display the medium to their
  users. The `mxc://` URL **can** refer to any medium included either in the
  article's content or in any other property in the event's data (such as its
  thumbnail).

Articles having a `date` property in the future **should** be ignored.

### Example

```json
{
    "signature": "0a1df56f1c3ab5b1",
    "signed": {
        "sender": "@acmenews:example.com",
        "room_id": "!LppXGlMuWgaYNuljUr:example.com",
        "type": "network.informo.article",
        "signatory_key": "IlRMeOPX2e0MurIyfWEucYBRVOEEUMrOHqn/8mLqMjA",
        "algorithm": "ed25519",
        "content": {
            "title": "Lorem ipsum",
            "thumbnail": "mxc://example.com/loremipsum",
            "content": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            "media_sigs": {
                "mxc://example.com/loremipsum": "Easojae4oogahluwah2o"
            }
        }
    }
}
```
