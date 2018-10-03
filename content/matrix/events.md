---
title: "Custom events"
weight: 3
---


## `network.informo.sources`

State event containing the list of available sources

### Source
- `className` (`string`): Type of the events containing the articles.
- `publicKey` (`string`): Public RSA key used for signing the articles.
- `publishers` (`string`): Matrix users allowed to publish articles.
- `name` (`string`): User readable source name.
- `description` (`string`): Short source description
- `languages` (`string[]`): Languages of the articles of the source. A single source should be able to provide several translations, like the country native language and English.
- `location` (`string`): Location of the source agency / reporters / main information subjects. Can be a precise address, a city, a country, ...



## `network.informo.news.*`

Timeline event containing a single article.

- `headline`: Article title
- `link`: Article original link on the source's website. Can be `null`.
- `author`: Article author
- `description`: Article introduction
- `content`: Article HTML content. The clients should sanitize it before displaying.
- `date`: Date of the article (UNIX timestamp)
- `signature`: Article cryptographic signature, with the source's key. Can be null if the article's source has no registered keys.



## Draft
- We need to allow any user to add his own custom source
- How can we allow only one user to modify the source he created? (using state events: I don't know, using source users: with account data)
- Can We can get rid of `Source.publishers` if events are signed ?
- Should we have one source per language or one source containing multiple languages?
- Handle article translations in a rss-friendly way
- Allow to specify other key types for signing
- Multiple keys per source?
- s/headline/title/ ?
- s/description/introduction/ ?
- What are the advantages of using a state event for network.informo.sources, over a simple timeline event?