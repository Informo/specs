---
title: "Trust level"
weight: 2
---

A TA's trust level is a relative integer which represents the depth in the trust management chain which trustworthiness is asserted by this TA.

This page mentions several kinds of trust levels, which are:

* TA-defined trust level, which is a value a TA can define as the trust level with which to trust another given TA with.
* user-defined trust level, which is a value the user forces for a given TA, if the client implementation allows it.
* effective trust level, which is the final value the client **must** use as the TA's trust level, whether it is the value defined for one of the above, or the result of a computation involving either (or several) of these.

A trust authority's trust level is to be understood as follows:

* A trust level of 0 means that only the sources certified by this trust authority as trustworthy **must** be considered trustworthy according to this TA.
* A trust level of 1 means that both the sources and the trust authorities certified by this TA as trustworthy **must** be considered trustworthy according to this TA (which means all of the trust authorities trusted by this TA **must** be considered with an effective trust level of 1).
* A trust level of 2 means that all of the sources this TA certifies to be trustworthy **must** be considered trustworthy according to this TA, and all of the trust authorities this TA certifies as trustworthy **must** be considered with an effective trust level of 1.
* *Et cetera*...

A trust authority holding a negative trust level means that this TA **must not** be trusted. The absolute value of a negative effective trust level **can**, however, be used by a client implementation in order to compute the distance in the user's trust network between the trust authority and the closest trusted TA and estimate the likelihood of the TA being trustworthy based on that distance, in order to make suggestions on TAs and sources to trust to the user.

## TA-defined & user-defined trust level

Let's consider:

* `TL(x)` a function returning the effective trust level for the TA `x`.
* `TATL(x,y)` a function returning the TA-defined trust level that the TA `x` defines for the TA `y`.
* `max(x,y)` a function returning the highest value between the integers `x` and `y`.
* `A` an example TA trusted by the user.
* `B` an example TA not trusted by the user at first, then trusted by the user.
* `C` an example TA trusted by `A` and `B`, but not by the user.

A trust authority `A` **can** define a trust level to trust another TA `C` with, which is named "TA-defined trust level". This trust level, expressed `TATL(A,C)` in this documentation, **must** be subject to the following constraints, as long as `C` isn't directly trusted by the user:

* `TATL(A,C) < TL(A)`, which means that `TL(C)` **must** be limited to a maximum value of `TL(A)-1`.
* In the event of `B` being trusted (either by another TA trusted by the user or by the user themselves), then `TL(C) < max(TATL(A,C),TATL(B,C))` **must** be fulfilled. Explained differently, if `TATL(B,C) > TATL(A,C)`, and the user's trust in `B` doesn't come from trusting `A`, then `TL(C)` **must** be limited to a maximum value of `TL(B)-1`.
* In the absence of any TA-defined trust level for `C`, client implementations **must** consider `TL(C)=0`.

A client implementation **should** also allow its users to define the trust level of a given TA, in order to give them more control over the articles and sources defined as trustworthy. This user-defined trust level differs from a TA-defined trust level only in that it is not constrained to a maximum value.

## Effective trust level

Let's consider

* `TL(x)` a function returning the effective trust level for the TA `x`.
* `TATL(x,y)` a function returning the TA-defined trust level that the TA `x` defines for the TA `y`.
* `max(x,y,z)` a function returning the highest value between the integers `x`, `y` and `z`.
* `A` an example TA trusted by the user.
* `B`, `C` and `D` three example TAs trusted by `A`.

As defined above, a TA's effective trust level is the value a client implementation **must** use as the final trust level for this TA. While computing it is already defined in the previous paragraph, it does not describe how to compute the effective trust level of a TA `A` that's directly trusted by the user, and not the target of a TA-defined trust level.

In such an event, the trusted TA `A`'s effective trust level **must** equal to its highest TA-defined trust level plus 1, which can be expressed as `TL(A)=1+max(TATL(A,B),TATL(A,C),TATL(A,D))`.

If the trusted TA `A` doesn't trust any TA, its effective trust level **must** be considered equal to the default value 0. If it does, but doesn't define trust levels for any of the other TAs it trusts, its effective trust level **must** be considered equal to 1, since we previously stated that the value to use in the event of the lack of a TA-defined trust level **must** be considered equal to the default value 0.

## Examples 🔧
