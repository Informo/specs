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

The article JSON object **must** be encapsulated in a [signed Matrix
event](/information-distribution/signature), with its signature generated with
one of the source's keys.

If the original news item contains media, these media **should** be uploaded to
the node using [Matrix's content repository
module](https://matrix.org/docs/spec/client_server/r0.4.0.html#id112).
🔧: Media signature

2️⃣: rest of the page