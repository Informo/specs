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


### Issues

Having a single `network.informo.sources` state event is problematic since Matrix does not allow a user to modify specific fields in the event data without allowing the user to modify the entire event.

If a user was granted full control over the source list, he would be able to impersonate other sources and send fake events.

#### Membership event unsigned field solution

The `m.room.membership` event has an `unsigned` field that can contains source / TA information.

> Membership event example:
> ```json
{
  "type": "m.room.member",
  "sender": "@acmenews:weu.informo.network",
  "state_key": "@acmenews:weu.informo.network",
  "content": {
    "membership": "join"
  },
  "unsigned": {
    "source": {
       "name": "ACME news",
       "description": "This is a dummy source",
       // ...
    }
  },
}
```

To modify the source / TA data, the users would need to quit and join back the room with the new `unsigned` field in the membership event.

Cons:

- To list all existing informo sources, the user will need to query and parse every user's membership event.

#### Community based solution

Any user that joins a specific community can act as a source.

Cons:

- Communities are currently not decentralized

#### Other future solutions requiring Matrix specs proposals

- Store source information as extended user profile information
- Allow specific state event types to be managed by specific users



## `network.informo.news.*`

Timeline event containing a single article.

- `headline`: Article title
- `link`: Article original link on the source's website. Can be `null`.
- `author`: Article author
- `description`: Article introduction
- `content`: Article HTML content. The clients should sanitize it before displaying.
- `date`: Date of the article (UNIX timestamp)
- `signature`: Article cryptographic signature, with the source's key. Can be null if the article's source has no registered keys.


## `network.informo.advised_sources`

State event containing the list of TAs that the client is advised to trust if they don't know who to trust.


## Draft
- Can We can get rid of `Source.publishers` if events are signed ?
- Should we have one source per language or one source containing multiple languages?
- Handle article translations in a rss-friendly way
- Allow to specify other key types for signing
- Multiple keys per source?
- s/headline/title/ ?
- s/description/introduction/ ?