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
module](https://matrix.org/docs/spec/client_server/r0.4.0.html#id112) and their
cryptographic signatures **should** be appended to the article's event.

## Matrix event `network.informo.article`

This message event **must** be sent and signed by a source Matrix user. See the
[signed Matrix event]({{<ref
"/information-distribution/signature#signed-matrix-event">}}) page for more
information.

If the sender is not a source user, the article **should** be ignored. If the
source registers itself afterwards, its previously sent articles **should**
become visible.

### Event data

| Parameter           | Type              | Req. | Description                                                                                                                                |
|:--------------------|:------------------|:----:|:-------------------------------------------------------------------------------------------------------------------------------------------|
| `title`             | `string`          |  x   | Article's headline.                                                                                                                        |
| `href`              | `string`          |      | URL of the article's original post (in case the article was sent to Informo from an existing website).                                     |
| `short_description` | `string`          |      | Short description or introduction to the article.                                                                                          |
| `author`            | `string`          |      | Full name of the article's author (when a single Informo source aggregates multiple writers).                                              |
| `thumbnail`         | `string`          |      | Preview image for the article. Must be a [`mxc://` URL](https://matrix.org/docs/spec/client_server/r0.4.0.html#id112).                     |
| `date`              | `int`             |      | Timestamp in milliseconds of the article's publication. If not provided clients should fall back to the Matrix event's creation timestamp. |
| `content`           | `string`          |  x   | Article HTML content. The HTML **must** be sanitized before being displayed in a client.                                                   |
| `media_sigs`        | `MediaSignatures` |      | Cryptographic signatures of the media embedded in the article.                                                                             |
| `custom`            | `object`          |      | Additional information for custom client implementations.                                                                                  |

Where:

* `MediaSignatures` is a map associating a [`mxc://`
  URL](https://matrix.org/docs/spec/client_server/r0.4.0.html#id112) with the
  signature of the media that's been uploaded at this URL. This signature
  **must** be generated using the same algorithm and public key that were used
  to sign the article's event. If this is not the case, or the signature can't
  be verified, client implementations **must not** display the media to their
  users. The `mxc://` URL **can** refer to any media included either in the
  article's content or in any other property in the event's data (such as its
  thumbnail).



Additional information:

- Articles having a `date` field in the future **should** be ignored.
- The `date` field uses the same timestamps as in the Matrix protocol, i.e.
  milliseconds since epoch.

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
