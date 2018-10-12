---
title: "What is Informo"
weight: 1
---

**TL;DR**: Informo is a decentralised and federated network that enables people
to share information and to bypass corporate or state censorship at some level.

### Bypassing censorship of information done differently

This section describes how most of other solutions used to bypass censorship of
information work, and how identifying their shortcomings lead to start building
Informo.

To describe the way most existing solutions work, let's consider
[alice](https://github.com/NInfolab/alice) as an example, which is the
censorship bypass solution currently in use by [Reporters Without
Borders](https://rsf.org/en/) as part of their [Collateral
Freedom](https://rsf.org/en/collateral-freedom) operation, and is representative
of how most solutions work 👀.

*alice* is basically a proxy/mirror that works by forwarding requests to a given
website, and streams the data it receives back to the user 👀. This means that
it needs to be "manually" set up on a server and configured with the websites
to be proxy'd in order to work. To ensure availability, Reporters Without
Borders hosts *alice* behind a CDN (*Content Delivery Network*), usually
[Fastly](https://www.fastly.com/) or [Amazon's
Cloudfront](https://aws.amazon.com/fr/cloudfront/). While these big players are
usually considered a threat for privacy, they are also very popular and many
websites and services depend on them. Blocking access to them would mean
disrupting all of those services and damaging local businesses.

The address for each proxy is then both sent out to activists in the field and
added to the list of proxies in the [RSF Censorship Detector browser
extension](https://addons.mozilla.org/en-US/firefox/addon/rsf-censorship-detector/).
This list is [hosted on
GitHub](https://github.com/RSF-RWB/collateralfreedom/blob/master/sites.json)
(for the same reason as the use of Fastly or Cloudfront), and downloaded by the
extension at each start of the browser.

While it's an amazing solution to bypass state censorship, it comes with a few
drawbacks. First, the administrators need to build an exhaustive list of the
news sources that can be proxy'd. This can be considered a minor issue since the
NGO (*Non-Governmental Organisation*) managing it is focused on the freedom of
the press, but it still implies giving absolute trust to the said organization.
Second, while blocking either Fastly or Cloudfront by a state is quite
difficult, it is still possible for them to block each single sub-domain
individually. In such an event, the administrators working on the Collateral
Freedom operation would have to change the proxies' addresses to new ones and
make them known to the relevant people by repeating the process described above.

### Bypassing censorship of information: the Informo way

Informo aims at addressing the issues mentioned in the previous section, by
considering the problem of censorship of information with a different angle. It
uses a federated network of servers talking with each other using the [Matrix
protocol](https://matrix.org/). A federation refers to a non-fixed set of
parties that can talk to all of the others parties involved. The Matrix protocol
defines ways to build such federations (named "rooms" in the protocol's
specifications), and assures that the history of all data sent through the
federation is saved by all of the parties involved.

One of the key mission of Informo is to build a large network of nodes
implementing the Matrix specification, spread as much as possible all around the
world. This is why Informo needs to be open and collaborative, because it relies
on giving people the ability to host their own node and expanding the network as
much as possible. The bet behind this thinking is that, while it's relatively
easy for a government or a company to block access to specific FQDN (*Fully
qualified domain names*, e.g. `foo.example.com`) that will need human
intervention to be renewed, it gets much more difficult when it comes to
blocking access to an always-changing list of, let's say, hundreds of FQDN,
knowing that the whole list must be denied access for the censorship to be
effective, and that anyone in the world with sufficient technical knowledge
(which Informo aims at keeping as low as possible) would be able to fire up
another node and plug it to the existing network for access to be restored.

Regarding the trust issue described the first section, Informo also introduces a
trust management mechanism, trying to set the balance between having to manually
manage every person you trust, and having one person deciding for everyone who
is trustworthy. In the current configuration, the Informo core team has slightly
more privileges than other parties, since new users will be advised (but not
forced) to start building their trust network by trusting Informo. While it's
not an ideal situation, the Informo core team believes it is a step towards a
less monolithic trust control.

### The meaning of "Informo"

"Informo" is a word which means "information" in the Esperanto language. Because
Informo is all about information, and making it accessible, it was only logical
that the name was centered on the word "information". Esperanto fits perfectly
with Informo's philosophy and needs for openness, as it is a language designed
to be universal and usable by anyone to communicate with everyone. On top of
that, the word itself sounded nice to the project's authors, thus was chosen as
the project's name.
