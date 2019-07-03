---
title: "Information distribution"
weight: 3
---

The main mission of Informo is distributing information. It does so by using a
federated network made of nodes, which are servers implementing the [Matrix
protocol specification](https://matrix.org/docs/spec/).

The Matrix specification defines an entity named "room", which can be considered
as a federation of nodes interacting with each other. Every piece of content
sent to a room is sent to every node involved in it. Informo uses a Matrix room
to propagate every piece of information, with an official `informo.network` room
administered by the [Informo core team]({{<ref "/informo/informo-core-team">}}),
however any external party is free to create its own room as long as information
is distributed through it accordingly with the current specifications. Client
implementations **should** allow users to retrieve information from several
rooms.
