---
title: "Node"
weight: 1
---

The federated network model Informo is based on is made of nodes communicating
with each other. Technically speaking, a node refers to a piece of software
implementing both the [client-server
specification](https://matrix.org/docs/spec/client_server/r0.4.0.html) and the
[federation
specification](https://matrix.org/docs/spec/server_server/r0.1.1.html) of the
[Matrix protocol](https://matrix.org), and connected to one or more federations
(i.e. Matrix rooms) which states and messages implements the Informo
specifications.

This page describes the behaviour nodes **must** implement in addition to the
Matrix protocol specifications. From a technical point of view, this behaviour
can be implemented either by embedding it in the piece of software implementing
the Matrix specifications, or by using external tools that interact with the
said piece of software.

## Ping

When a message is sent by a user to a node `A`, this node will relay the message
to every other node in the federation. If the link between `A` and another node
`B` is broken for an indefinite amount of time (e.g. because of the network
censoring any communication between `A` and `B`), `B` will never get the
message. However, if another node `C` emits a message, and the link between `C`
and `B` allows the latter to receive the message, `B` will notice a hole in the
messages timeline and [request the missing message from
`C`](https://matrix.org/docs/spec/server_server/r0.1.1.html#post-matrix-federation-v1-get-missing-events-roomid).

In order to avoid a node being left out of a federation, nodes **must** send out
a small message, named "ping", to the Matrix room every twelve hours. This
way, a node that's cut from most of a federation except for a few nodes will end
up getting all of the information it missed. If a node is offline when it is
supposed to send out a ping it **should** send it as soon as it gets back
online.

This ping **must** take the form of a Matrix timeline event of the
`network.informo.ping` type, and have an empty content (`{}`).

## Entry nodes

An entry node is a node that allows client implementations to connect to the
federations this node is in, and retrieve information from them. An entry node
**must** allow guest access.

On top of that, an entry node **must** expose a file at the address
`https://SERVER_NAME/.well-known/informo/info` which content is a map in the
JSON format, which associates Matrix room IDs with a map implementing the
following structure:

| Parameter    | Type   | Req. | Description                                                   |
|:-------------|:-------|:----:|:--------------------------------------------------------------|
| `entry_node` | `bool` |  x   | Whether the node is an entry node for this federation (room). |

One entry of this map **can** be the wildcard value "`*`" instead of a Matrix
room ID, in which case it means its content defines default values for the
parameters it contains.

If the file lacks a wildcard entry, or the wildcard entry's content lacks one or
more parameter(s), the following default values **must** be used for the missing
parameter(s):

| Parameter    | Default value |
|:-------------|:--------------|
| `entry_node` | `false`       |

If an entry exists for a federation and its content define different values for
any parameters, these values **must** be used for this federation.

### Simple example

Let's consider a node that has `example.com` as its server name, and wants to
act as an entry node for the federation which Matrix room ID is
`!Nei7aeg5aefub:informo.network`.

This node **must** serve a file at the address
`https://example.com/.well-known/informo/info` with the following content:

```
{
    "!Nei7aeg5aefub:informo.network": {
        "entry_node": true
    }
}
```

### Blacklist example

Let's consider the a node that has `example.com` as its server name and wants to
act as an entry node to any federation except for the one which Matrix room ID
is `!Nei7aeg5aefub:informo.network`.

This node **must** serve a file at the address
`https://example.com/.well-known/informo/info` with the following content:

```
{
    "*": {
        "entry_node": true
    },
    "!Nei7aeg5aefub:informo.network": {
        "entry_node": false
    }
}
```

### Client implementations behaviour

#### Computing a list of entry nodes

Client implementations **must** provide user with a list of known entry nodes,
for at least one federation, that's up to date at the time of the
implementation's release. Client implementations **must** also allow users to
use an unknown node as an entry node (provided that this node implements the
requirements to be an entry node).

Once a federation is joined (see the section [below]({{<relref
"#joining-a-federation">}})), client implementations **must** retrieve and save
the list of joined nodes in the federation. This can be done by retrieving the
list of [joined
users](https://matrix.org/docs/spec/client_server/r0.4.0.html#get-matrix-client-r0-rooms-roomid-joined-members)
for the federation, then processing this list in order to only keep the server
part of the Matrix user IDs (i.e. what's after the colon (`:`)). Client
implementations **must** save this list in case the node they're currently using
becomes unreachable.

Client implementations **should** weight this list according to the number of
trusted [TAs]({{<ref "/trust-management/trust-authority">}}) that trust a given
node.

Client implementations **must not** try to fetch the `/.well-known/informo/info`
file of each node once it has computed this list, because this would be harmful
to its users' privacy.

#### Reaching an entry node

A list of entry nodes only contains the nodes' server names, and not their
address and port, which can differ. As an example, the Matrix specifications
would allow a node living at `node.example.com` to use Matrix identifiers ending
with `:example.com`.

In order to find the effective address and port to reach a node at, client
implementations **must** implement the server discovery through `.well-known`
URI logic, as [described in the Matrix
specifications](https://matrix.org/docs/spec/client_server/r0.4.0.html#server-discovery).

{{% notice note %}}
If the server discovery leads to a final `IGNORE` instruction (as specified in
the link above), then client implementations **must** use the node's server name
as the address and port the node can be reached at, using the `443` port as a
default value.
{{% /notice %}}

In the event of an entry node that's currently being used becoming unreachable,
clients implementations **should** use their list of nodes (either hardcoded by
the implementor or computed from the list of users in the federation) to provide
its user(s) with alternative entry nodes to use.

#### Joining a federation

Client implementations **must** provide users with the room ID of at least one
federation, and allow users to input custom values for the room ID of the
federation to join.

When reaching a node in order to join a federation, client implementations
**must** try to retrieve the `/.well-kown/informo/info` file of the node (while
following 30x redirects). If the file doesn't exist, or doesn't state that the
node can be used as an entry node for the given federation, then client
implementations **must** give up and try another node. While trying to use this
node as an entry node anyway can be technically working, this rule exists in
order to avoid node administrators possible legal issues resulting from people
using a node to access specific types of contents against its administrator's
will.

Client implementations **should** store the result of the attempt at retrieving
the `/.well-kown/informo/info` file of a node in a cache with a time-based
invalidation policy.

Once both an entry node and a room ID have been selected as the one to use in
order to join a federation, whether this selection originated from an explicit
action by a user or, either partially or entirely, from a client
implementation's inner mechanisms, client implementations **must** send a [join
request](https://matrix.org/docs/spec/client_server/r0.4.0.html#post-matrix-client-r0-join-roomidoralias)
to the selected node using the federation's room ID.

In order to optimise the likelihood of success of the join request, client
implementations **should** provide server names for at least additional 3 nodes
when performing the join request using `server_name` query parameters. This will
ensure that, if the node doesn't already have at least one user in the
federation, it can fall back by asking another node (either of the 3 or more
provided) which does to [help it
join](https://matrix.org/docs/spec/server_server/r0.1.1.html#get-matrix-federation-v1-make-join-roomid-userid).
These nodes are used only by the entry node, and only during this interaction,
therefore client implementations don't need to make sure that these nodes are
entry nodes in this case.

While connected to a node, client implementations **should** keep track of
received pings in order to better filter out inactive nodes when the entry node
they're currently using becomes unreachable.

## Other types of nodes

Nodes that aren't entry nodes (e.g. a node with no guest access) are named
"relay nodes". Although they cannot be used by client implementations in order
to retrieve articles from the Matrix room, they are still useful as they can
relay articles to other nodes that are out of reach from the articles'
emitter(s). For example, if a node `A` can't reach a node `B` but can reach a
node `C`, even if `C` isn't an entry node, `A`'s information will eventually
manage to reach `B` via `C` thanks to pings.
