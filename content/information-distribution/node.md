---
title: "Node"
weight: 1
---

The federated network model Informo is based on is made of nodes communicating with each other. Technically speaking, a node refers to a piece of software implementing both the [client-server specification](https://matrix.org/docs/spec/client_server/r0.4.0.html) and the [federation specification](https://matrix.org/docs/spec/server_server/unstable.html) of the [Matrix protocol](https://matrix.org), and connected to one or more federations (i.e. Matrix rooms) which states and messages implements the Informo specifications.

This page describes the behaviour nodes **must** implement in addition to the Matrix protocol specifications. From a technical point of view, this behaviour can be implemented either by embedding it in the piece of software implementing the Matrix specifications, or by using external tools that interact with the said piece of software.

## Ping

When a message is sent by a user to a node `A`, this node will relay the message to every other node in the federation. If the link between `A` and another node `B` is broken for an indefinite amount of time (e.g. because of the network censoring any communication between `A` and `B`), `B` will never get the message. However, if another node `C` emits a message, and the link between `C` and `B` allows the latter to receive the message, `B` will notice a hole in the messages timeline and [request the missing message from `C`](https://matrix.org/docs/spec/server_server/unstable.html#post-matrix-federation-v1-get-missing-events-roomid).

In order to avoid a node being left out of a federation, nodes **must** send out a small message, named "ping" (2️⃣), to the Matrix room every twelve hours. This way, a node that's cut from most of a federation except for a few nodes will end up getting all of the information it missed. If a node is offline when it is supposed to send out a ping it **should** send it as soon as it gets back online.

## Entry nodes

An entry node is a node that allows client implementations to connect to the federations this node is in, and retrieve information from them. An entry node **must** allow guest access, and **must** define at least one [alias](https://matrix.org/docs/spec/client_server/r0.4.0.html#room-aliases) to the Matrix room.

Client implementations **must** provide users with an updated list of entry nodes with their addresses and the aliases to use to join the federation the node is in. Clients implementations **must** also provide users with a way to input custom values for the address of the entry node to use and the alias of the Matrix room to join.

Once a Matrix room is joined, client implementations **must** retrieve and save the [list of aliases](https://matrix.org/docs/spec/client_server/r0.4.0.html#m-room-aliases) for this room. In the event of an entry node that's currently being used being unreachable, clients implementations and **must** use this list to provide users with an updated list of alternative entry nodes and aliases to use. The address of the node managing a given alias can be retrieved through a [DNS query](https://github.com/matrix-org/synapse/#setting-up-federation).

{{% notice note %}}
Nodes that aren't entry nodes are named "relay nodes".
{{% /notice %}}
