---
title: "Trust level"
weight: 2
---

A trust authority **should** declare its own trust level. One TA's trust level is the depth in the trust management chain which trustworthiness is asserted by this TA.

A trust authority's trust level is to be understood as follows:

* A trust level of 0 means that all of the sources certified by this trust authority as trustworthy **must** be considered as trustworthy according to this TA.
* A trust level of 1 means that both the sources and the trust authorities certified by this trust authority as trustworthy **must** be considered as trustworthy according to this TA (which means all of the trust authorities trusted by this TA **must** be considered as if their own trust level was 0).
* A trust level of 2 means that all of the sources this TA certifies to be trustworthy **must** be considered as trustworthy according to this TA, and all of the trust authorities this TA certifies as trustworthy **must** be considered as if their own trust level was 1.
* *Et cetera*...

If a trust authority doesn't declare its own trust level, clients **should** use the default value for trust level, which is 1 (👀: maybe not the best value, can be too restrictive).

A client **might** allow its users to force the trust level of each trust authority to give them more control over the articles and sources defined as trustworthy. A trust authority **can** also force the trust level to trust another TA with. If a TA *A* trusts another TA *B* without declaring a specific trust level, and a user decides to trust *A* (and not *B*), then *B* **must** be considered as trusted with a trust level `TL(B)=TL(A)-1`, where `TL(x)` is a function returning the trust level of the TA `x`.

If a user chooses to trust a trust authority, and then to trust another trust authority that's already trusted by the first TA, the second TA's declared trust level (or 1 if there is no declared trust level for this TA) **must** takes precedence over the trust level that was assumed from the first TA's trust level.

## Example

Let's consider the example below.

```text
                     ACME.org (TA)
      -------->   Trusted by Informo   -----> JohnDoeNews.org (Source)
      |           Level 0 (assumed 0)    |    Trusted by ACME.org
      |                                  |
Informo (TA)                             +--> SomeGuyNews.org (Source)
Level 1                                       Trusted by ACME.org
      |
      |           Reporters.org (TA)
      -------->   Trusted by Informo   -----> SomeCountryNews.org (Source)
                  Level 1 (assumed 0)    |    Trusted by Reporters.org
                                         |
                                         +xx> SomeNGO.org (TA)             xxxxx> ...
                                              Trusted by Reporters.org
                                              Level 1

--> trusted
xx> not trusted

(TA): Trust authority
(Source): Information source
```

Here, the user chooses to trust the *Informo* trust authority, which has a trust level of 1. This means that *ACME.org* and *Reporters.org*, which are two trust authorities trusted by *Informo*, are to be trusted too, along with the sources they trust themselves. *SomeNGO.org*, along with all of the sources and trust authorities it certifies as trustworthy, is not to be trusted as *Informo*'s trust level makes it too far in the trust management chain.

However, if the user chooses to trust *Reporters.org* by itself (on top of trusting *Informo*), *Reporters.org*'s initial trust level (which is 1) takes precedence, which means that *SomeNGO.org* and all of the sources and trust authorities it certifies as trustworthy are to be considered as such. The same result could be reached if the Informo TA declares trusting *Reporters.org* with a trust level of 2.

## Page example 🔧

*TODO: Determine what to do with this section*

![](/images/design-page-trustring.svg)
