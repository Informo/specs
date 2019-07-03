---
title: "Trust level"
weight: 2
---

A TA's trust level is a relative integer which represents the depth in the trust
chain which trustworthiness is asserted by this TA.

This page mentions two kinds of trust levels, which are:

* link trust level, which is a defined value associated with the trust link
between either the user and a TA, or between a TA and another TA it trusts.
* effective trust level, which is the final value client implementations
**must** use as the TA's trust level, whether it is a link trust level or the
result of a computation involving it.

A trust authority's effective trust level is to be understood as follows:

* A trust level of 0 means that only the sources trusted by this TA **must** be
considered trustworthy by client implementations.
* A trust level of 1 means that both the sources and the trust authorities
trusted by this TA **must** be considered trustworthy by client implementations
(which means all trust authorities trusted by this TA **must** be considered
with an effective trust level of 0).
* A trust level of 2 means that all of the sources this TA certifies to be
trustworthy **must** be considered trustworthy by client implementations, and
all of the trust authorities this TA certifies as trustworthy **must** be
considered with an effective trust level of 1.
* *Et cetera*...

A trust authority holding a negative effective trust level means that this TA
**must not** be trusted. The absolute value of a negative effective trust level
**can**, however, be used by a client implementation in order to compute the
distance in the user's trust network between the trust authority and the closest
trusted TA and estimate the likelihood of the TA being trustworthy based on that
distance, in order to make suggestions on TAs and sources to trust to the user.

## Calculating the effective trust level

Let's consider:

* the situation described by the schema below:

{{<
    img
    src="trust-level-calc.svg"
    alt="Example schema of a trust network in which two TAs, A and B, both trust another TA C, which itself trusts another TA D. The links between two TAs, for example A and C, are annotated with LTL(A,C)."
>}}

* `A`, `B`, `C` and `D` four example TAs.
* `TL(x)` a function returning the effective trust level for the TA `x`.
* `LTL(x,y)` a function returning the trust level of the link between `x` (being
either a TA or the user) and the TA `y`.
* `max(x,y)` a function returning the highest value between the integers `x` and
`y`.
* `min(x,y)` a function returning the lowest value between the integers `x` and
`y`.
* `C` trusted by both `A` and `B`.
* `D` trusted by `C`.

In this situation, the effective trust level of `D` **must** be both inferior to
`TL(C)` and inferior or equal to `LTL(C,D)`, i.e. `TL(D) <= min(TL(C)-1,
LTL(C,D))`. When verifying this rule, client implementations **should**
generally use the highest values possible for `TL(x)` and `LTL(x,y)`, but they
**can** also use lower values in order to provide stricter trust management.

In the case of `C`, which is trusted by both `A` and `B`, client implementations
**must** compare `min(TL(A)-1, LTL(A,C))` and `min(TL(B)-1, LTL(B,C))` and pick
the highest value as the effective trust level for `C`.

#### General rule

In a general manner, the effective trust level of any TA named `𝑋` that is
trusted by multiple TAs named `A`, `B`, `C`, ... can be expressed as :

```
TL(𝑋) <= max(
  min(TL(A) - 1, LTL(A,𝑋)),
  min(TL(B) - 1, LTL(B,𝑋)),
  min(TL(C) - 1, LTL(C,𝑋)),
  ...
)
```

#### User trusting a TA

A user can choose to trust a specific TA, which overrides the computed value for
this TA's effective trust level, thus ignores any value calculated using the
general rule above.

If the user trusts a TA with a specific trust level (i.e. they defines a fixed
value as the link trust level between themselves and the TA), the TA's effective
trust level **must** be equal to this user-defined value. This lets the user
limit the depth of their own trust network.

If the user trusts a TA `A` with no specific trust level, a TA `B` trusted by
`A` **should** be trusted by the user with an effective trust level equal to the
link trust level `A` defines for `B` plus 1. If `A` trusts more than one TA,
then its effective trust level **should** be the link trust level of the trust
link with the highest one plus 1. This lets the user fully trust both the TA and
its trust network. This is similar to using an infinite value for `A`'s
effective trust level.

If the user trusts a TA `A` and a TA `B`, and `B` trusts `A`, then the effective
trust level of `A` **must** be equal to the link trust level between by the user
and `A` (which is either a fixed user-defined value, or defined by the link
trust levels of the trust links originating from this `A`).

## Examples

Let's consider:

* `TL(x)` a function returning the effective trust level for the TA `x`.
* `LTL(x,y)` a function returning the trust level of the link between `x` (being
either a TA or the user) and the TA `y`.

* `min(x,y)` a function returning the lowest value between the integers `x` and
`y`.
* the schema below:

{{<
    img
    src="trust-level-graph.svg"
    alt="Example schema of a trust network in which the user trusts a TA A with a link trust level of 2, which itself trusts a TA E with a link trust level of 0 and a TA B with a link trust level of 1. B trusts a TA C with a link trust level of 1 (but C's effective trust level is 0), which itself trusts a TA D with a trust level of 1 (but D's effective trust level is -1, which means that D is untrusted). E trusts a TA F with a trust level of 1 (but F's effective trust level is -1, which means that F is untrusted)."
    width="100"
>}}

In this example, and because of the rules stated above, it is interesting to
note that:

* `TL(A)` is 2, which means that the user may or may not have explicitly defined
a link trust level between themselves and `A`. Indeed if they didn't, then
`TL(A) = LTL(A,B)+1 = 1+1 = 2`.
* `B` trusts `C` with a trust level of 1 (i.e. `LTL(B,C) = 1`). However, `TL(B) =
1` in the user's trust network, and `TL(C) < TL(B)`, so `TL(C)` is brought
down to 0. This can also be expressed as `TL(C) = min(TL(B)-1, TL(B,C)) =
min(1-1, 1) = 0`.
* The same rule applies to `TL(D)`. This means that `TL(D) < 0`, so `D` isn't
trusted.
* `LTL(A,E) = 0`, which means that `A` explicitly states not to trust any TA
trusted by `E`, causing `F` to be untrusted. `TL(E)` can also be expressed as
`TL(E) = min(TL(A)-1, LTL(A,E)) = min(2-1, 0) = 0`.

Let's consider the user trusting `E`:

{{<
    img
    src="trust-level-graph-userdef2.svg"
    alt="Same example schema as above, except for the fact that the user itself trusts E with a link trust level of 1. This means that now F becomes trusted because its effective trust level becomes 0."
    width="100"
>}}

In the schema above, it is interesting to note that, now:

* `LTL(user,E)` is being overridden by a user-defined value of 1 (we know this
because it would otherwise equal `LTL(E,F)+1 = 2`).
* Because there's now a trust link between the user and `E` and it takes
precedence over any other trust link targeting `E`, `TL(E) = 1`
* `F` is now trusted because `min(TL(E)-1 , LTL(E,F)) = 0`.
