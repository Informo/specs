---
title: "Event signature"
weight: 4
---


Ideally every Informo-related Matrix events should be signed with some keys.

## Article

An article can be optionnaly signed by the Informo-feeder bot with a RSA private key, which public key must match one provided by the associated source.

We allow unsigned articles, but only if the source does not provide any public key.


## Source

Source events should be signed with a key owned by the associated source Matrix user.



## TA

TA events should be signed with a key owned by the associated TA Matrix user.





## Draft
- What if the source list was the list of users that joined a specific Matrix Community? (cons: we may not be able to retrieve an history of source data)
- Can we use the Matrix E2E encryption keys to sign events (without encrypting them).
