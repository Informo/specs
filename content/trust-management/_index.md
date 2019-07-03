---
title: "Trust management"
weight: 4
---

One of Informo's key issues is to allow as much information as possible through
the federated network, with some level of mitigation against disinformation or
propaganda. The set of mechanisms used to address this is called "trust
management" in this documentation.

Informo's trust management mechanisms are designed to ensure as much as possible
the integrity and the origin of all of the information traveling through the
federation. It aims at building a trust network made of cryptographic signatures
users can rely on, possibly starting from signing keys that are embedded into
client implementations, all the way to the information itself. The idea is to
consider the network hostile, therefore relying as much as possible on
operations that are local and/or hard to interfere with. This is done by relying
on [trust authorities]({{<ref "/trust-management/trust-authority">}}), which are
third-party entities such as NGOs and non-profit organisations, to certify the
trustworthiness of an [information source]({{<ref
"/information-distribution/source">}}), which itself certifies the integrity of
the information it publishes.

In order to prevent the network from acting as a censorship machine, trust
management **must** be considered as an optional feature, meaning everyone
**must** be able to publish information through the network and to read all of
the information that has been published (i.e. without blocking access to
anything or including any sort of strong filtering based on parameters the user
doesn't control). With this in mind, trust management **must** be a process that
ends up giving the user only an indication on whether a news item might be
trustworthy or not, letting them make their own choice on whether or not to
ignore this indication.

This section describes how Informo's trust management mechanisms **must** work
with all of the parties involved.
