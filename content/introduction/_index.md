---
title: "Introduction"
weight: 1
---

### Welcome to Informo's specifications

This documentation aims at giving the world a complete understanding of
Informo's inner mechanisms, how it works and interacts with external elements in
order to fulfil its mission.

Informo needs to be as open and collaborative as possible for people to get
involved, thus for it to work. For this reason, this documentation is also open
and collaborative, which means that anyone can submit change requests by
following the [specifications change submission protocol](/introduction/scsp).

### What is Informo?

Informo is a project aiming to fight online censorship of information by
allowing information sources to share their news through a federation of servers
(i.e. a group of servers that can talk to each other) using [the Matrix
protocol](https://matrix.org). Matrix allows the information to be shared
between a potentially large amount of servers, each storing their own copy and
serving it to anyone requesting it.

This significantly hampers censorship because:

* every server knows about the information, so the whole federation must be
  blocked in order to censor it. The list of servers participating in a
  federation can continuously grow and change, which can render such a blockade
  practically very hard, if not impossible, to manage.

* the Matrix protocol is built upon
  [HTTP](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol), which is
  one of the most (if not the most) used protocols over the Internet, rendering
  the identification of Matrix traffic (and therefore Informo traffic) hard (but
  not impossible) to identify. On top of that, using security protocols such as
  [TLS](https://en.wikipedia.org/wiki/Transport_Layer_Security) would render
  such identification even harder.

You can learn more about Informo's approach on [this dedicated
page](/informo/what-is-informo/).

The technical details for the distribution of information through the federation
are described in [their own section](/information-distribution).

On top of that, Informo also provides trust management mechanisms which are
designed to let readers have a reliable idea of the origin and authenticity of a
news item without having to rely on a potentially insecure network. This set of
mechanisms is described in [its own section](/trust-management).

### Get involved!

Any people wishing to get involved in any part of Informo, whether it is working
on the specifications, contributing to the software we build, translations, or
any other possible form of contribution (including taking part in the ongoing
chatter about how to improve Informo) is more than welcome to join our [Matrix
discussion room](https://matrix.to/#/!LppXGlMuWgaYNuljUr:weu.informo.network) or
our [IRC channel](https://webchat.freenode.net/?channels=%23informo).
