---
title: "Article"
weight: 3
---

An article is a news item published by a
[source](/information-distribution/sources) to the Matrix room. It **must**
include the item's content, title, author, date (formatted following the
[ISO8601](https://tools.ietf.org/html/rfc3339) standard) and original URL (or an
empty string if the item was only published through Informo), along with a
signature coming from its source, and be published on the publication name space
that has been declared by its source. The article **can** also include optional
properties, such as the item's description, read duration, NSFW marker, etc..

The signature **must** be generated from one of the source's public signature
verification keys (using the source's declared signing algorithm), and a string
containing all of the item's information, and **must** be formatted the same way
as follows:

```
title=Lorem ipsum&author=Cicero&date=2006-01-06T15:04-07:00&url=https://lipsum.com/&content=Lorem ipsum dolor sit amet, consectetur adipiscing elit.
```

In the example string above, the target article is titled "Lorem ipsum", was
written by "Cicero" on January 1st 2006 and can be found at
"[https://lipsum.com/](https://lipsum.com/)" with the content "Lorem ipsum dolor
sit amet, consectetur adipiscing elit.".

If the original news item contains media, these media **should** be uploaded to
the node using [Matrix's content repository
module](https://matrix.org/docs/spec/client_server/r0.4.0.html#id112).

## Matrix event `network.informo.article`

This message event **must** be sent and signed by a source Matrix user. See
[signed Matrix event](/information-distribution/signature/#signed-matrix-event)
for more information about signing.

If the sender is not a source user, the article **should** be ignored. If the
source registers itself afterwards, its previously sent articles **should**
become visible.


### Event data

|      Parameter      |   Type   | Req. |                                                                     Description                                                                     |
| ------------------- | -------- | :--: | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| `title`             | `string` |  x   | Article's headline.                                                                                                                                 |
| `href`              | `string` |      | URL of the article's original post (in case the article was sent to Informo from an existing website).                                              |
| `short_description` | `string` |      | Short description or introduction to the article.                                                                                                   |
| `author`            | `string` |      | Full name of the article's author (when a single Informo source aggregates multiple writers).                                                       |
| `thumbnail`         | `string` |      | Preview image for the article. Must be a [`mxc://` url](https://matrix.org/docs/spec/client_server/r0.4.0.html#id112).                                                                                              |
| `date`              | `int`    |      | Timestamp in milliseconds when the article was published. If not provided clients should fall-back to the timestamp when the matrix event was sent. |
| `content`           | `string` |  x   | Article HTML content. The HTML **must** be sanitized before being displayed in a client.                                                            |
| `custom`            | `object` |      | Additional information for custom client implementations.                                                                                           |

Additional information:

- Articles having a `date` field in the future **should** be ignored.
- The `date` field uses the same timestamps as in the Matrix protocol, i.e. milliseconds since epoch.


### Example

```json
{
    "content": {
        "algorithm": "ed25519",
        "sender_key": "IlRMeOPX2e0MurIyfWEucYBRVOEEUMrOHqn/8mLqMjA",
        "signature": "0a1df56f1c3ab5b1",
        "signed": {
            "title": "Lorem ipsum",
            "content": "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        }
    }
}
```
