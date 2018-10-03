---
title: "Trust management"
weight: 2
---

One of Informo's key issues is allowing as much information as possible through the federated network, with some level of protection against intentional disinformation or propaganda. The set of mechanisms used to address this issue is what's being called "trust management" in this documentation.

In order not to become a censorship machine itself, Informo has to embed trust management mechanisms that are optional, meaning they **must** let everyone publish information through the network and let everyone read all of the information that has been published through the network (i.e. without blocking access to any of it or including any sort of filtering mechanism either upstream or downstream that's based on parameters the user doesn't control). With this in mind, trust management **must** be a process that ends up in only giving the user an indication on whether a news item might be trustworthy, and not in any case one that decides what gets displayed on the user's client.

This section aims at providing a precise description of how Informo's trust management mechanisms must work and all the parties involved in these mechanisms.
