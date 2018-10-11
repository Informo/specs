---
title: "Terminology"
weight: 3
---

The current section defines fixed definitions for words or expressions that are used over this documentation.

#### Article

An article refers to any news item that is sent over the Informo network. It is defined by its content, which, right now, is limited to text and images, and various metadata such as its title, its author(s), its publication date, etc..

#### Federation

An federation is a Matrix room that is shared and synchronized across multiple nodes.

#### Feed

A feed refers to the aggregation of articles sent over the Informo network by one or more source(s). It usually, but not always, refers to the aggregation of the *n* latest articles sent by all of the sources a user is subscribed to.

#### Node

A node is a piece of software implementing both the [client-server specification](https://matrix.org/docs/spec/client_server/r0.4.0.html) and the [federation specification](https://matrix.org/docs/spec/server_server/unstable.html) of the [Matrix protocol](https://matrix.org), and connected to one or more Informo federations. Typically it can be a server running [Synapse](https://github.com/matrix-org/synapse).

#### Source, Information source

An information source, sometimes referred to as just "source", refers to an individual or group of people that send articles over the Informo network. A source itself is defined by a name, a cryptographic key, and some metadata such as a description or an avatar. If supported by the Informo client in use, a user can subscribe to a source to add its latest articles to their feed.

#### Trust Authority (TA)

A trust authority refers to an entity, whether it is an individual or a group of people, which role is to build up a list of sources it certifies as legit and worthy of trust. This list can also include trust authorities the TA certifies as qualified to state on the trust worthiness of other sources.

#### Trust Level

The trust level is a representation of how much a user or a trust authority is trusting other trust authorities, affecting how far a user or trust authority can delegate the verification of sources and trust authorities.

#### Trust Link

A trust link is an unidirectional connection between a user or trust authority and another trust authority they trust. The concept is similar to the edges in [graph theory](https://en.wikipedia.org/wiki/Graph_theory). 

#### Trust network, Trust chain

A user's trust network, also referred to as their trust chain, is the network formed by the trust authorities and sources they trust, either directly or indirectly. If explicitly specified as such, these expressions can also refer to the network formed by all of the trust authorities and sources known within Informo's federated network.
