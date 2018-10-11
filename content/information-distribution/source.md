---
title: "Source"
weight: 1
---

A source is an entity holding the responsibility of publishing information through the Matrix room. Before publishing any information, a source **must** register itself as such on the room, including data on the organism or individual operating the source, the publication language and the publication name space (2️⃣: a Matrix event type), along with one or more public signature verification keys that will be used to assert the integrity of the information it publishes.

A source **must** be trusted by trust authorities operated by organisms it trusts and is in contact with outside of Informo. If at least one of a source's private keys gets compromised, the source **must** update its list of public signature verification keys, and every trust authority trusting the source **must** compute and issue a new signature taking the updated list of keys into account. The reason behind this is to encourage trust authorities to communicate with their trusted sources, estimate how much compromised the source is (i.e. one key vs all of the keys vs the source's entire Matrix account), and take the actions it deems necessary.

In such an event, client implementations **should** consider articles posted prior to the key being compromised as possibly, but not surely trustworthy.

{{% notice note %}}
In the event of an organism or individual publishing information in several languages, this organism or individual **must** register a source for each publication language, with each registration containing the relevant data.
{{% /notice %}}

2️⃣: rest of the page
