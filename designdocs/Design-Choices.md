This document aims to capture our thinking around the more technical design choices of Causes, freeing up the manifesto to focus on more conceptual analysis. We expect implementers to refer to this document.

# Centralised / Distributed / Replicated ?

Distributed and replicated : some data sets like crash reports will be too large to want to replicate willy-nilly. Others like current project plans will be extremely useful offline. So support both. In particular the ‘I am a private company’ use case is actually a great exemplar for many subtle things we’ll need.

# No hard dependencies on specialised web services

We can use anything for which completely offline implementations exist. Anything else would prevent running private sites.

# The signs/symptoms/plans split?

A bit of a strong-feeling thing. The signs/symptoms split is intended to separate out things that are human focused, where you need discussion and interrogation, from things that are machine orientated, where mass data analysis and automation rule. It may be a very soft split when looking at code and data models, who knows. One particular aspect where it may be different is the volume (lots of symptoms, relatively few signs); the rigour(machine gathered, human wrote); and the discussion (most symptoms will be auto aggreggated and not discussed at all.

The plans split is intended to solve the friction that arises when a report from a user - a symptom - is marked as a duplicate of another report from a different user not because they are the same, but because the same proposed change would fix them both. (This happens a lot). Then, if the proposed change is not actioned (due to resources, or code review feedback or …) the project has lost data - what were two different issues that could be used to triangulate are now one, and if the change actually used to solve one of them doesn’t solve both, you have an unhappy user.

# Web UI layer

Should be uncontentious, but - hell, see any modern web design argument. js. websockets.

# Atom

Lets us use [PSHB](https://code.google.com/p/pubsubhubbub/) and be efficiently indexed by google etc. Yes it's a little more ugly than webhooks but unlike webhooks it lets anyone watch anything via PSHB.

# PSHB for events

We want push to clients, which is most sanely websockets these days. Avoid making the server stateful by using a dedicated websocket notification server subscribed to the client’s topics via PSHB.
