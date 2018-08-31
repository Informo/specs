---
title: "Usage"
weight: 1
---


## State events

## Timeline events




## One room per network vs one room per source

### One room per network pros
- Only the matrix server administrator can know which articles/sources are read by a specific guest user, by looking at which filters are used in API requests.
- If we had one room per source, we would need a "central" room for listing existing news sources, or some other ways to retrieve all Informo rooms on the federation (can be challenging since matrix servers don't discover other federated rooms until one of its users joins the room).

### One room per network cons
- Can have some performance issues if there are a lot of activity in the room
    + But Matrix API allows to filter specific event types, so it should not be a big issue
- We are more vulnerable to matrix-related exploits, since one attacker could disrupt the entire official Informo news network.


## Draft

- being able to aggregate news from different rooms using a single client would be nice.
