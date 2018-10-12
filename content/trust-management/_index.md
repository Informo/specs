---
title: "Trust management"
weight: 4
---

One of Informo's key issues is to allow as much information as possible through
the federated network, with some level of mitigation against intentional
disinformation or propaganda. The set of mechanisms used to address this is
called "trust management" in this documentation.

Informo's trust management system is designed to ensure as much as possible the
integrity and the origin of all of the information traveling through the
federation, and the identity of all parties involved. It aims at building a
trust network made of cryptographic signatures users can rely on, possibly
starting from signing keys that are embedded into client implementations, all
the way to the information itself. the idea is to consider the network hostile,
therefore relying as much as possible on operations that are local and/or hard
to interfere with. This is done by relying on [trust
authorities](/trust-management/trust-authority), which are third-party organisms
such as NGOs and non-profit organisations, to certify the trustworthiness of an
[information source](/information-distribution/source), which itself certifies
the integrity of the information it publishes.

In order not to prevent the network to act as a censorship machine, Informo has
to keep trust management optional, meaning it **must** let everyone publish
information through the network and let everyone read all of the information
that has been published through the network (i.e. without blocking access to
anything or including any sort of strong filtering based on parameters the user
doesn't control). With this in mind, trust management **must** be a process that
ends up giving the user only an indication on whether a news item might be
trustworthy or not, letting them make their own choice on whether or not bypass
this indication.

This section describes how Informo's trust management mechanisms must work with
all the related parties involved.
