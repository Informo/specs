---
title: "Trust level"
weight: 2
---

A TA's trust level is a relative integer which represents the depth in the trust management chain which trustworthiness is asserted by this TA.

This page mentions two kinds of trust levels, which are:

* link trust level, which is a defined value associated with the trust link between either the user and a TA, or between a TA and another TA it trusts.
* effective trust level, which is the final value the client **must** use as the TA's trust level, whether it is the value defined for one of the above, or the result of a computation involving either (or several) of these.

A trust authority's effective trust level is to be understood as follows:

* A trust level of 0 means that only the sources trusted by this TA **must** be considered trustworthy by the client.
* A trust level of 1 means that both the sources and the trust authorities trusted by this TA **must** be considered trustworthy by the client (which means all trust authorities trusted by this TA **must** be considered with an effective trust level of 0).
* A trust level of 2 means that all of the sources this TA certifies to be trustworthy **must** be considered trustworthy by the client, and all of the trust authorities this TA certifies as trustworthy **must** be considered with an effective trust level of 1.
* *Et cetera*...

A trust authority holding a negative trust level means that this TA **must not** be trusted. The absolute value of a negative effective trust level **can**, however, be used by a client implementation in order to compute the distance in the user's trust network between the trust authority and the closest trusted TA and estimate the likelihood of the TA being trustworthy based on that distance, in order to make suggestions on TAs and sources to trust to the user.

## Calculating trust level

Let's consider:

* the situation described by the schema below:

![](/images/trust-level-calc.svg)

* `A`, `B`, `C` and `D` four example TAs.
* `TL(x)` a function returning the effective trust level for the TA `x`.
* `LTL(x,y)` a function returning the trust level of the link between `x` (being either a TA or the user) and the TA `y`.
* `max(x,y)` a function returning the highest value between the integers `x` and `y`.
* `min(x,y)` a function returning the lowest value between the integers `x` and `y`.
* `C` trusted by both `A` and `B`.
* `D` trusted by `C`.

In this situation, the effective trust level of `D` **must** be both inferior to `TL(C)` and inferior or equal to `LTL(C,D)`, i.e. `TL(D) <= min(TL(C)-1, LTL(C,D))`. Client implementations **should** generally use the highest possible value, but they **can** also use lower values in order to provide stricter trust management.

The effective trust level of `C` **must** be the highest trust level value calculated for each link (`A➡️C` and `B➡️C`) using the rule above.

#### General rule

In a general manner, the effective trust level of any TA named `𝑋` that is trusted by multiple TAs named `A`, `B`, `C`, ... can be expressed as :

```
TL(𝑋) <= max(
  min(TL(A) - 1, LTL(A,𝑋)),
  min(TL(B) - 1, LTL(B,𝑋)),
  min(TL(C) - 1, LTL(C,𝑋)),
  ...
)
```

#### User trusting a TA

A user can choose to trust a specific TA, which overrides the computed value for this TA's effective trust level, thus ignores any value calculated using the general rule above.

If the user trusts a TA with a specific trust level, the TA's effective trust level **must** be equal to this user-defined value. This lets the user limit the depth of its trust network.

If the user trusts a TA `A` with no specific trust level, a TA `B` trusted by `A` **should** be trusted by the user with an effective trust level equal to the link trust level `A` defines for `B`. This lets the user fully trust both the TA and its trust network. Client implementation **can** do this by using an infinite value for `A`'s effective trust level.


## Examples

![](/images/trust-level-graph.svg?width=100%)

- `B` trusts `C` with a trust level of 1. `TL(C) = min(TL(B) - 1, TL(B,C)) = min(1 - 1, 1) = 0`.
- `A` trusts `E` with a trust level of 0. `TL(E) = min(TL(A) - 1, TL(A,E)) = min(2 - 1, 0) = 0`.
- `TL(D) < 0`, meaning TA and its sources are not trusted.

This is what happens if the user decides to trusts `E`:
![](/images/trust-level-graph-userdef2.svg?width=100%)

- `TL(E)` is overridden unconditionally by the `TL(user,E)` value.
- `F` is now trusted.
