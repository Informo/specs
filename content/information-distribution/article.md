---
title: "Article"
weight: 2
---

An article is a news item published by a [source](/information-distribution/sources) to the Matrix room. It **must** include the item's content, title, author, date (formatted following the [ISO8601](https://tools.ietf.org/html/rfc3339) standard) and original URL (or an empty string if the item was only published through Informo), along with an [ed25519](https://ed25519.cr.yp.to/) signature coming from its source, and be published on the publication name space that has been declared by its source. The article **can** also include optional properties, such as the item's description, read duration, NSFW marker, etc..

The ed25519 signature **must** be generated from one of the source's public signature verification keys, and a string containing all of the item's information, and **must** be formatted the same way as follows:

```
title=Lorem ipsum&author=Cicero&date=2006-01-06T15:04-07:00&url=https://lipsum.com/&content=Lorem ipsum dolor sit amet, consectetur adipiscing elit.
```

In the example string above, the target article is titled "Lorem ipsum", was written by "Cicero" on January 1st 2006 and can be found at "[https://lipsum.com/](https://lipsum.com/)" with the content "Lorem ipsum dolor sit amet, consectetur adipiscing elit.".

If the original news item contains media, these media **should** be uploaded to the node using [Matrix's content repository module](https://matrix.org/docs/spec/client_server/r0.4.0.html#id112).

2️⃣: rest of the page
