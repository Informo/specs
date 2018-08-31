---
title: "Users"
weight: 2
---


## Guest users

Users wanting to read articles on the Informo network needs to be registered using a guest account. Guest accounts consists of a randomly generated user name, and a single token used for authentication.

The guest account can be thrown away at any time, since it does not store any kind of information (except the user name and auth token). User IP and specific API requests is only known by the Matrix homeserver administrator which the user connects to, it is not "spread" across the Matrix federation

We must register guest accounts because anonymous access to Matrix APIs is very limited.


## Trust Authority users

Trust authorities uses a registered Matrix account, which they need to log in with in order to modify trusted source/TA list.


## Source users

Sources uses a registered Matrix account, which they need to log in with in order to send content. Generally this account will only be used by the Informo Feeder bot, to send signed RSS articles.
