---
title: "Terminology"
weight: 3
---

The current section defines fixed definitions for words or expressions that are
used over this documentation.

#### Article

An article refers to any news item that is sent over the Informo network. It is
defined by its content, which, right now, is limited to text and images, and
various metadata such as its title, its author(s), its publication date, etc..

#### Client implementation

A client implementation is a piece of software implementing the related parts of
the Informo specifications in order to allow users to connect to a federation
and retrieve information from it.

#### Federation

A federation is a set of nodes that are able to communicate with each other,
similar to a mesh network. In this specifications, Matrix rooms are sometimes
referred to as federations, as they can be broadly considered as federations
with state machines.

#### Node

A node is a piece of software implementing both the [client-server
specification](https://matrix.org/docs/spec/client_server/r0.4.0.html) and the
[federation
specification](https://matrix.org/docs/spec/server_server/r0.1.1.html) of the
[Matrix protocol](https://matrix.org), and connected to one or more Informo
federations.

#### Entity

An entity is the abstract representation of an individual or an organism
actively interacting over Informo, and is technically represented by a finite
set of at least one Matrix user identifier. This definition doesn't include
client implementations' users, who interact passively with Informo (by reading
Matrix events rather than sending them), nor nodes (which can't be represented
by a finite set of Matrix user identifiers), therefore neither of them are
considered as entities. An entity must register itself on the Informo
federation(s) it whishes to interact on. The Informo specifications currently
defines two types of entities: sources and trust authorities (which are defined
below).

#### Source, Information source

An information source, sometimes referred to as just "source", refers to an
individual or group of people that send articles over the Informo network. A
source itself is defined by a name, a cryptographic key, and some metadata such
as a description or an avatar. If supported by the Informo client in use, a user
can subscribe to a source to add its latest articles to their feed.

#### Trust Authority (TA)

A trust authority refers to an entity, whether it is an individual or a group of
people, which role is to build up a list of sources it certifies as legit and
worthy of trust. This list can also include trust authorities the TA certifies
as qualified to state on the trust worthiness of other sources.

#### Trust Level

The trust level is an indication on how much a client implementation trusts a
trust authority. It is a relative integer representing the maximum depth in the
user's trust network that can be reached from the said trust authority. It can
be either defined by the user (to control what its client must trust as
precisely as possible) or by a trust authority for another trust authority (to
delegate the certification of trustworthiness).

#### Trust Link

A trust link is an unidirectional connection between a user or trust authority
and another trust authority they trust. The concept is similar to the edges in
[graph theory](https://en.wikipedia.org/wiki/Graph_theory).

#### Trust network, Trust chain

A user's trust network, also referred to as their trust chain, is the network
formed by the trust authorities and sources they trust, either directly or
indirectly. If explicitly specified as such, these expressions can also refer to
the network formed by all of the trust authorities and sources known within
Informo's federated network.
