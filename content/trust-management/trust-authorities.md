---
title: "Trust authority"
weight: 1
---

One key party of Informo's trust management mechanisms is called "trust authorities", sometimes also referred as "TA". As defined in [this documentation's terminology](/intro/terminology/#trust-authority-ta), a trust authority is an entity that asserts the trustworthiness of another entity, whether this entity is an information source or another trust authority.

A user **must** be able to chose which trust authority they want to give their absolute trust to, whether that trust authority is itself trusted by another TA or not. This model follows the outlines of [Delegative Democracy](https://en.wikipedia.org/wiki/Delegative_democracy), as it allows a user to either trust a source based on their own research and criteria, or delegate the determination of a source's trustworthiness to another party.

If a user choses to trust a specific trust authority, all sources and trust authorities that have been determined as trustworthy **must** be considered as trustworthy by clients in accordance with the chosen TA's trust level (documented in [the related section](/trust/trust-level/)).

A trust authority's main responsibility is to assert the trustworthiness of a source or of another TA. This means that the TA **must** publish a list of all of the sources and trust authorities it trusts and keep it up to date, and give the information needed to certify the sources' and trust authorities' authenticity. 2️⃣

A trust authority **must** also be able to list sources that it explicitly blacklists for being compromised or ethical reasons, along with the reasons for each addition to the blacklist (2️⃣: identification on MXID, reasons identifier).

## Client implementations

In the event of a source being trusted by a trust authority A and blacklisted by a trust authority B, given that both A and B are being trusted by the user, clients **must** display a warning message to users, indicating that, although some of the user's trusted trust authorities are still asserting the source as being trustworthy, some others explicitly stated that the source should not be trusted anymore, with a hint at the reason specified in the blacklist entry.

In order to help its users assert the trustworthiness of a source, a client **might** include the display of a graph showing the location of the source in Informo's trust network. It **might** also include a view promoting sources that have been certified as trustworthy by several trust authorities that the user trusts.

In order to try to give the same level of exposure between all existing parties taking part in Informo, a client **might** also include a view showing sources or trust authorities that are less likely to be promoted. This can be done by computing the "trust distance", i.e. the shortest path in Informo's trust network's graph, to each source and trust authority, and promoting the sources and trust authorities with the longest one.
