---
title: "Node"
weight: 1
---

The federated network model Informo is based on is made of nodes communicating
with each other. Technically speaking, a node refers to a piece of software
implementing both the [client-server
specification](https://matrix.org/docs/spec/client_server/r0.4.0.html) and the
[federation
specification](https://matrix.org/docs/spec/server_server/unstable.html) of the
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
`C`](https://matrix.org/docs/spec/server_server/unstable.html#post-matrix-federation-v1-get-missing-events-roomid).

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
**must** allow guest access, and **must** define at least one
[alias](https://matrix.org/docs/spec/client_server/r0.4.0.html#room-aliases) to
the Matrix room.

Client implementations **must** provide users with an updated list of entry
nodes with their addresses and the aliases to use to join the federation the
node is in. Clients implementations **must** also provide users with a way to
input custom values for the address of the entry node to use and the alias of
the Matrix room to join.

Once a Matrix room is joined, client implementations **must** retrieve and save
the [list of
aliases](https://matrix.org/docs/spec/client_server/r0.4.0.html#m-room-aliases)
for this Matrix room. This can be done by processing all of the `m.room.aliases`
events in the state of the Matrix room, each of them containing the list of
aliases defined for a given node. The content for such an event looks like this:

```
"aliases": [
    "#alias1:example.com",
    "#alias2:example.com"
]
```

The example above shows the content of the `m.room.aliases` state event for the
node which uses `example.com` as its server name.

Client implementations **must** process these lists of aliases to generate a map
associating all of the entry nodes for this Matrix room with the aliases they
provide for this room.

### Reaching an entry node

Because the list of aliases only list the nodes' server names, and not their
FQDN, a node might not be reachable at the address defined by its server name.
In order to find the effective FQDN and port to reach a node at, client
implementations **must** perform a DNS query on an `SRV` record for the
`_matrix._tcp` sub-domain of the server's name which, in the example above,
would look like `_matrix._tcp.example.com`. If such a record doesn't exist,
client implementations **should** consider that the node is reachable using its
server name as its FQDN, and the default Matrix encrypted federation port,
`8448`, as its port.

Most Matrix homeservers can also be reached through the standard `443` HTTPS
port. Whether there's a Matrix `SRV` DNS record for a node or not, client
implementations **should** try reaching the said node using the `443` port
before trying reaching it using any other port. This means a node's address and
port resolution **should** follow the following workflow:

1. Try retrieving a Matrix `SRV` DNS record from the node's server name.
2. If the DNS record exists, try reaching the node using the FQDN extracted from
the record and the `443` port.
3. If step 2 succeeds, consider the FQDN extracted from the DNS record and the
`443` port as the final parameters to reach the node (i.e. consider the node
unreachable if those parameters don't work).
4. If step 2 fails, consider the FQDN and port extracted from the DNS record as
the final parameters to reach the node (i.e. consider the node unreachable if
those parameters don't work).
5. If the DNS record doesn't exist, try reaching the node using its server name
as its FQDN and the `443` port.
6. If step 5 succeeds, consider the node's server name and the `443` port as the
final parameters to reach the node (i.e. consider the node unreachable if those
parameters don't work).
7. If step 5 fails, consider the node's server name and the `8448` port as the
final parameters to reach the node (i.e. consider the node unreachable if those
parameters don't work).

This should result in making the network traffic generated by Informo client
implementations more difficult to detect and filter on.

If a client implementation's maintainer(s) decide not to use port 443, their
client implementation **must** implement the following workflow:

1. Try retrieving a Matrix `SRV` DNS record from the node's server name.
2. If the DNS record exists, consider the FQDN and port extracted from the
DNS record as the final parameters to reach the node (i.e. consider the node
unreachable if those parameters don't work).
3. If the DNS record doesn't exist, consider the node's server name and the
`8448` port as the final parameters to reach the node (i.e. consider the node
unreachable if those parameters don't work).

{{% notice tip %}}
Web-based client implementations **can** use the [DNS over
HTTPS](https://tools.ietf.org/html/rfc8484) standard to perform DNS queries over
HTTPS instead of standard DNS queries which they might not be able to perform.
{{% /notice %}}

In the event of an entry node that's currently being used becoming unreachable,
clients implementations **must** use the generated map to provide its user(s)
with alternative entry nodes and aliases to use. Client implementations **can**
use received pings in order to filter out the inactive nodes from this list.

### Joining a federation

Once both an entry node and a room alias have been selected as the one to use in
order to join a federation, whether this selection originated from an explicit
action by a user or, either partially or entirely, from a client
implementation's inner mechanisms, client implementations **must** send a [join
request](https://matrix.org/speculator/spec/HEAD/client_server/unstable.html#post-matrix-client-r0-join-roomidoralias)
to the selected node using the selected alias.

## Other types of nodes

Nodes that aren't entry nodes are named "relay nodes". Although they cannot be
used by client implementations in order to retrieve articles from the Matrix
room, they are still useful as they can relay articles to other nodes that are
out of reach from the articles' emitter(s). For example, if a node `A` can't
reach a node `B` but can reach a node `C`, even if `C` isn't an entry node,
`A`'s information will eventually manage to reach `B` via `C` thanks to pings.
