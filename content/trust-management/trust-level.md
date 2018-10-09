---
title: "Trust level"
weight: 2
---

A TA's trust level is a relative integer which represents the depth in the trust management chain which trustworthiness is asserted by this TA.

This page mentions two kinds of trust levels, which are:

* link trust level, which is a defined value associated with the trust link between either the user and a TA, or between a TA and another TA it trusts.
* effective trust level, which is the final value the client **must** use as the TA's trust level, whether it is the value defined for one of the above, or the result of a computation involving either (or several) of these.

A trust authority's effective trust level is to be understood as follows:

* A trust level of 0 means that only the sources certified by this trust authority as trustworthy **must** be considered trustworthy according to this TA.
* A trust level of 1 means that both the sources and the trust authorities certified by this TA as trustworthy **must** be considered trustworthy according to this TA (which means all of the trust authorities trusted by this TA **must** be considered with an effective trust level of 1).
* A trust level of 2 means that all of the sources this TA certifies to be trustworthy **must** be considered trustworthy according to this TA, and all of the trust authorities this TA certifies as trustworthy **must** be considered with an effective trust level of 1.
* *Et cetera*...

A trust authority holding a negative trust level means that this TA **must not** be trusted. The absolute value of a negative effective trust level **can**, however, be used by a client implementation in order to compute the distance in the user's trust network between the trust authority and the closest trusted TA and estimate the likelihood of the TA being trustworthy based on that distance, in order to make suggestions on TAs and sources to trust to the user.

## Link trust level

Let's consider:

* `TL(x)` a function returning the effective trust level for the TA `x`.
* `LTL(x,y)` a function returning the trust level of the link between `x` (being either a TA or the user) and the TA `y`.
* `max(x,y)` a function returning the highest value between the integers `x` and `y`.
* `A` an example TA trusted by the user.
* `B` an example TA not trusted by the user at first, then trusted by the user.
* `C` an example TA trusted by `A` and `B`, but not by the user.

Both TAs and the user can list the TAs they trust, therefore creating trust links between them and the TAs they trust. These trust links can hold a specific trust level that is used to compute the effective trust level of the link's target.

A link's trust level, expressed `LTL(A,C)` in this documentation, **must** be subject to the following constraints, as long as `C` isn't directly trusted by the user:

* `LTL(A,C) < TL(A)`, which means that `TL(C)` **must** be limited to a maximum value of `TL(A)-1`.
* In the event of `B` being trusted (either by another TA trusted by the user or by the user themselves), then `TL(C) < max(LTL(A,C),LTL(B,C))` **must** be fulfilled. Explained differently, if `LTL(B,C) > LTL(A,C)`, and the user's trust in `B` doesn't come from trusting `A`, then `TL(C)` **must** be limited to a maximum value of `TL(B)-1`.
* In the absence of any defined link trust level for `C`, client implementations **must** consider `TL(C)=0`.

A client implementation **should** also allow its users to define the trust level of a given TA they directly trust (i.e. `LTL(user,A)`), in order to give them more control over the articles and sources defined as trustworthy. This user-defined trust level differs from one defined by a TA only in that it is not constrained to a maximum value. If defined, this user-defined trust level **must** always be considered as the effective trust level for that TA, overriding all other values (either computed or defined by a TA). If not defined, the value of `LTL(user,A)` **must** be considered as the value for `TL(A)`, which computation is described below.

## Effective trust level

Let's consider

* `TL(x)` a function returning the effective trust level for the TA `x`.
* `LTL(x,y)` a function returning the TA-defined trust level that the TA `x` defines for the TA `y`.
* `max(x,y,z)` a function returning the highest value between the integers `x`, `y` and `z`.
* `A` an example TA trusted by the user.
* `B`, `C` and `D` three example TAs trusted by `A`.

As defined above, a TA's effective trust level is the value a client implementation **must** use as the final trust level for this TA. While computing it is already defined in the previous paragraph, it does not describe how to compute the effective trust level of a TA `A` that's directly trusted by the user.

In such an event, the trusted TA `A`'s effective trust level **must** equal to its highest link trust level plus 1, which can be expressed as `TL(A)=1+max(LTL(A,B),LTL(A,C),LTL(A,D))`.

If the trusted TA `A` doesn't trust any TA, its effective trust level **must** be considered equal to the default value 0. If it does, but doesn't define trust levels for any of the other TAs it trusts, its effective trust level **must** be considered equal to 1, since we previously stated that the value to use in the event of the lack of a TA-defined trust level **must** be considered equal to the default value 0.

## Examples 🔧
