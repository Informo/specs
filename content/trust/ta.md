---
title: "Trust Authority"
weight: 1
---

User can chose to trust specific TAs (Trust Authority), so that any sources trusted by this TA can be marked as trusted as well. A TA can also trust other TAs, so they can promote a list of reliable TAs.

This model works a bit like [Delegative Democracy](https://en.wikipedia.org/wiki/Delegative_democracy): it allows users to either do their own research to determine if a source is trustable, or delegate this work to an entity that he trusts.

The goal is to permit the user to build his own trusted network of sources, that will help him select legit information sources.

# Trust level / depth

A TA can be trusted at different levels:
- Level 0: Trust only this TA sources
- Level 1: Trust this TA sources and all sources trusted by any TA this TA trusts
- Level 2: ...


### Example
```text
        -------->           ACME.org(TA)             ----> JohnDoeNews.org(Source)
       |            Trusted through Informo, level 0   |    Trusted by ACME.org
InformoTeam(TA)                                         -> SomeGuyNews.org(Source)
 Trust level 1                                              Trusted by ACME.org
       |                  Reporters.org(TA)          ----> SomeCountryNews.org(Source)
        -------->   Trusted through Informo, level 0        Reporters.org
```

In this example, the user choses to trust _InformoTeam_ with a trust level of 1, which causes _ACME.org_ and _Reporters.org_ to be trusted TAs, and makes _JohnDoeNews.org_, _SomeGuyNews.org_ and _SomeCountryNews.org_ to be trusted sources.

### Page example
![](/images/design-page-trustring.svg)

# Going further

- Let a TA flag a source / TA to be explicitly untrusted (for compromised or unethical source)
- Display a graph for a single source, to see who trust the source and at which level
- Promote sources that are trusted by many TAs trusted by the user
- We are able to calculate the "trust distance", ie the shortest path to a trusted TA. Sources or TAs that has a long "trust distance" will be more likely to be unreliable and should be promoted.
