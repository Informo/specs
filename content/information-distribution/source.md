---
title: "Source"
weight: 1
---

A source is an entity holding the responsibility of publishing information through the Matrix room. Before publishing any information, a source **must** register itself as such on the room, including data on the organism or individual operating the source, the publication language and the publication name space (2️⃣: a Matrix event type), along with one or more cryptographic signing keys that will be used to assert the integrity of the information it publishes. If a source has been certified by one [trust authority](/trust-management/trust-authority) or more, its registration **must** include the identity and a signature from each trust authority asserting its trustworthiness.

These cryptographic signatures **must** include the source's identifier (2️⃣: it's MXID), its name and the list of its signing keys. This means that if one of the source's private keys gets compromised, the trust authorities certifying the trustworthiness of the source **must** issue a new signature, ensuring the authenticity of all of the keys included in the new list. The reason behind this is to encourage a trust authority to estimate how much compromised the source is (i.e. one key vs all of the keys vs the source's entire Matrix account), and take the actions it deems necessary.

{{% notice note %}}
In the event of an organism or individual publishing information in several languages, this organism or individual **must** register a source for each publication language, with each registration containing the relevant data.
{{% /notice %}}

2️⃣: rest of the page
