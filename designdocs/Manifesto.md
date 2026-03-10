# Causes

A bug tracker built to free developers from the tedium of manual assessment and ‘bug gardening’. Uses automation and statistics to present information about the project and the experiences users are having. Bridges the gap between users and developers by explicitly gathering symptoms and signs from users, while letting developers track proposed fixes separately. Inspired by many conversations around what bug trackers need to deliver for projects.


Causes models bug reports as the interaction between four separate things:
* A project timeline which records things like releases, commits and the like. This takes the place of the ‘project’ or ‘component’ in other bug tracking tools.
* Signs: observed issues with the project. For instance, a segfault on the 3/4/2013 by version 0.2 of the project is a sign of a problem. Signs often live in different systems and Causes merely stores summary or reference information to them. Most bug tracking tools do not have a matching concept, but recently crash databases are evolving and these do represent the same thing. Signs are generally worked with in aggregate.
* Symptoms: human reported and discussed issues with the project. These take the place of regular bug reports in tools like bugzilla and Launchpad. ‘I would like to be able to do X’ or ‘When I try Y this weird thing happens’ are typical symptoms. Workarounds and ways to mitigate typically get written about in the symptom.
* Plans which document intended changes to the project. Sometimes called specifications or story cards. Plans may stand alone or be linked to Symptoms or Signs that they are intended to address. Plans can range from very small - indeed trivial - to large complex documents with numerous dependencies. Developer discussion about diagnosis and investigation would typically occur on a plan.


# Why?

Good bug trackers make a big difference to projects. They help users communicate with developers and find solutions/workarounds to issues they have. They help developers find out about issues with their products and converge on good solutions. They help project managers assess the health of the project and plan/manage releases; they help multiple service providers coordinate work on a project.


At the time of writing there are many bug trackers that do a comprehensive job, but most either are too complex or still not-quite-right.


We are arrogant enough to think we can do better.


Should we contribute our ideas to an existing tracker like Launchpad, Trac or Bugzilla? Perhaps. On the plus side existing implementations have existing communities, code, infrastructure and user bases. On the down side they have existing communities, code, infrastructure and users that provide a brake on radical do-overs : and what we are proposing is in some ways very different. If we provide a minimal implementation that gathers sufficient interest existing tools may gather the social buy-in necessary to change - and we could stop our new tool. Win. Or we might gather a community to maintain it and just be another [better] tool. Either way, doing a new tool seems like less overall effort, and since we have a significant number of ‘what if’ questions to answer, the easier we can answer them the better.

# Minimum viable product

The smallest implementation we can use ourselves that would be usable:
1. Persistent storage [so data entered is kept]
2. Plans, Project and Symptom objects [so that the basic workflow is encodable]. Signs - later, perhaps a specialised Symptom?
3. An interface of some sort[a]. Text files files for editing and a CLI query interface may be enough to see if there is value.
Alternative MVP
The smallest implementation we can use ourselves that would be usable:
1. Persistent storage [so data entered is kept]
2. Ability to import an existing bug database and run some sort of automated analysis over it, split bugs into plans etc. See how it looks.
3. An interface of some sort[a]. Text files files for editing and a CLI query interface may be enough to see if there is value.
________________

# Features

## Dedicated user, developer and project manager interfaces[b]

Users are usually not really interested in bug reports. Users are interested in
* solving/working around the problem they have encountered,
*  knowing if it is fixed in a later release,
*  and assessing if/when they will be able to get a fix (that hasn’t been written yet)
* Obtaining developer time to fix their problem
Tracking symptoms (user prose describing a problem) and signs (automatically gathered data about a problem - such as a segfault) separately from proposed changes to the project and  separately from tracking what gets done when provides dedicated interfaces that meets users needs, developers needs and the needs of folk that do planning (common in commercial organisations that may also use Causes). [not validated - experience with Bazaar, Ubuntu etc was a strong indicator - this can be decomposed into smaller validated and nonvalidated bits]

## Sensible assumptions

In the absence of explicit decisions, Causes makes sensible assumptions - and updates those as the facts change. For instance, a symptom many users are experiencing is assumed to be more important to the project than one that only a single user has reported. If a developer overrides that, the override sticks until removed. [Importance Not validated.]

## Does one thing well

Causes is a new take on bug trackers. This is a rich subject that is worth doing well. Causes is not a project management tool[c], nor a kanban tool, nor a VCS history viewer, nor <fill in the blanks>. Causes offers an API permitting it to trigger events in other systems, and likewise be updated in response to events in other systems. We consider it a bug if slick automation cannot be easily created to connect Causes to services such as VCS hosting, CI systems, crash reporting systems …

## Work with your bugs on the road

We’ve all been in the situation of needing to work with bugs at a conference with shocking wifi, or copy a bunch of symptoms for reproduction of a problem while travelling. Causes expects such situations [d]and allows you to run a local Causes repository that integrates with your projects main online repository.

## Work privately with a public project’s bugs

Many organisations work on public projects but cannot share all their discussion about particular issues with the public project. They may have a weak fork of the project in fact and have some bugs that are local only. Wouldn’t it be great to use the same bug tracking software upstream and locally, with a full copy of the public data set mirrored into your local repository? Causes supports this as just another case of distributed data.

## Integrates with your existing data[e]

There are many sources of data that help manage a bug report. Commits to VCS can be excluded as causes if they happened after the report was filed. Crash database reports can provide backtraces and variable values. Bug reports in the bug trackers of distributions can provide more context or reproduction instructions. Commits can indicate that a bug is probably fixed. The same core logic that drives offline access and behind-the-firewall replication is used to work with other data sources.


Manage work in progress
While Causes is not a Kanban system, it does know about the work in-progress within the system: plans that have been made but not actioned, plans that are pending review, symptoms where discussion about reproducing it has stalled and so on. Causes shows you a clear list of the things you have started but not finished, including things where other people are waiting on you, or you are waiting on other people. Similarly it can show a project wide view of in progress work, which lets you see what everyone using the same Causes repository is up to. [unvalidated, but seems like a direct application of the automate-tedious-stuff principle].


Clearly shows what you and your collaborators have done
The flip side of knowing what you are doing is knowing what you have done (within Causes, obviously!). Causes can summarise this for you, making it easy to talk about what you have done for a project. Similarly, see what has happened in the whole project recently, over the last month or year. [not validated; the keep-aware-of-things aspect is fairly obvious; the advertise-myself less so]


# Implementation
1. Open source. We all have day jobs and are not interested in doing a startup in competition with atlassian/github/pivotal/fogbugz... Probably Apache V2/MIT. Not validated.
2. Clean and lean. We don’t want a POS bag of everything to maintain. We may end up creating several narrow but cooperating projects[f] (such as core, notification/subscriptions,web UI). Validated by past experience.
3. Easily deployed. Minimally for local testing, but also as we’re not commercially funded we don’t anticipate running a central service - so if folk cannot deploy it, they cannot use it. Validated by past experience.
4. Easily operated. Again, if it cannot be run by non-developers, we are likely going to paint ourselves into a run-a-central-service or only-we-use-it corner.

# Project / governance

1. Code on github.
2. CI from get-go
3. Weak consensus decision making
4. Canvas for assessing the project - http://www.netprofess.com/canvas.php#3f614c35cee955cfd1678920be9d1d46f8a93c31

# Values[g]
1. Only encourage effort that is valuable to projects. Validated by self-learning from initial team: wasted effort [h]is something we don’t like.
2. Respect time and effort involved in contributions from all parties: users, intermediaries, developers, project leaders. Relatedly, encourage people to be good to each other, even though there will be conflicting interests and opinions. Validated by reactions from ourselves and others on violations of this value.
3. Work well for projects with mildly different needs. Not validated; can be validated as soon as we encounter a ‘can’t use this without X’ situation.
4. Learn and infer as much as possible. Not validated; is perhaps the key hypothesis about the design.
5. Keep human/intentional things and machine set/inferred/gathered things separate[i]. Not validated, perhaps a derivative of ‘learn and infer’.


# Archetypes

## Projects
1. Freegen - a small personal project, 5-10 open bugs, activity happens rarely. Does lightweight releases, does not track multiple stable versions. Users are highly technical. Bugs are usually shallow and hard to confuse with other bugs. No related projects.
2. Market - a small commercially funded project, 2000 open bugs, low but regular activity from users. Developer activity a few times a week from 3-4 developers. Does releases, tracks multiple stable versions. Users are often non-technical but sometimes very technical. Actively tries to bring users across the fold to become developers. Bugs can be very subtle and hard to differentiate from other bugs. Has related projects for plugins, and multiple organisations doing commercial support. Bugs often require private data of users to reproduce.
3. BigVector - a big commercially funded project with 5000 open bugs, activity from hundreds of users a week, and likewise from hundreds of developers. Does releases, tracks multiple stable versions. Users are usually technical but not aware of project internals. Bugs are generally easy to differentiate. Has related projects for different facets of the project, multiple organisations doing commercial development and support. Bugs rarely require private data to reproduce, but the project has regular security vulnerabilities that have to be disclosed with care.


## Users
1. Fred - a user of Market, Fred is not very technical, but enthusiastic and happy to try new code branches. Fred has a couple of bugs open with Market that are driving him up the wall.
2. Gary - a user of BigVector, Gary has a commercial support contract with BigVendor, 4 open bugs that affect him, and is a personal contributor to Market.
3. Jo -  the developer of Freegen, works on it a few hours a month, as time permits.
4. Mary - a developer on BigVector, working for BigVendor. Spend most of her time writing code with some planning and user support time thrown in for good measure. Deals with private data from BigVendor clients when needed, and is part of the release team for BigVector.


## Organisations
1. Speculative, a web 2.0 company that funds Market. Drives Market as a project and collaborates with ServiceCo supporting users of Market.
2. ServiceCo, a systems integrator, has users using Market. ServiceCo manages the bugs filed by their users and takes care of analysing and fixing them.
3. SwitchCo - a network switch vendor, contributes to the development of BigVector, has users using it and provides support to them. Manages tickets from their users in a private system.
4. MachineCo - a PC server vendor, contributes to the development of BigVector, has users using it and supports them. Also manages tickets in private.

# Prior art / inspiration
* Launchpad has a very good bug tracker. It’s UI is very complex, it is very hard to run private instances, has a very limited notification/event raising mechanism. It has no machine learning embedded in it. It conflates work tracking and planning, does little to support kanban - and work tracking and defect tracking are separate (but see mpt's spec for an issue tracker for future plans). LP is very straightforward to use, with a battle-tested balance between capability and clutter. LP also models the needs of Linux distributions well - and is quite unique in that regard.
* Pivotaltracker is an agile story tracker - not a bug tracker (though it can double for small projects and integrate for big ones.
* Bugzilla - well known, but not in any sense simple.
* http://pqxx.org/development/libpqxx/wiki/AllSoftwareIsBroken documents an experiment that tries to serve both users and developers in the categorisation of bug reports.
* https://lists.launchpad.net/launchpad-dev/msg07824.html is the start of a thread about modelling of bugs in Launchpad, which includes some useful principles.
* uservoice.com
* git (a very successful distributed source control system: most interesting as prior art for an effective user model of distributed data).

# Axioms
That is, things we are going to assume but not try to validate :)
* We can make something useful in our spare time, despite us all having interesting day jobs

# Non-features


## Cross-project bugs
The cross-project bug feature in Launchpad is arguably a special case of replicated discussion about a distributed bug. As we don’t want to build a single point of service, this implies that cross-project bugs as a specific feature is uninteresting. We may support federation, and if so there is no particular reason to preclude federating with a bug in another project in the same tracker instance.

As such, cross-project bugs are not a first class feature.


## Distribution bug tracking[j]
Tracking bugs for distributions is somewhat different to bug tracking for individual projects. They do interact in that many software projects are shipped by distributions, and thus symptoms users experience may be farmed from the shipping distributions bug trackers. However, there are at least a thousand times more software projects than Linux distributions, and proportionally fewer chances to be adopted as the bug tracker for a distribution.  It will be nice if what we build is suitable for tracking the bugs of a distribution, and we won’t reject volunteer work to make it suitable.


But we won’t set out to make it suitable at this stage.


## Project timelines, Kanban, VCS integration etc etc.
While such things are important, we want to keep Causes focused. As such, we won’t add things to Causes itself that are not part of its necessary core features... but we may well create a collection of ‘you probably want this’ API scripts / extensions. For instance, integrating with github is probably a must-do; ditto trello.

# Architecture
Background on various decisions can be found https://docs.google.com/a/robertcollins.net/document/d/1eVSwZoRmz9-JWKQaDQWfIMpOE8JRpWSH-awSBMYlqIw/edit#

## Repository
A repository stores data for a project; repositories can be easily and quickly created, and interacted with entirely via a CLI. CLI access uses local credentials. Repositories can trigger local hooks in response to events. Repositories are individually queryable, and have no authentication. They are local artifacts but may be configured with network identities (e.g. HTTP, SMTP etc) to allow push notifications to reach them for replicated items. Repositories store only what replication subscriptions it has, not where it should send notifications. All actions are notified by local hooks. SMTP notifications can be hooked in there, and HTTP notifications are PSHB new content notifications (generated only when the HTTP daemon is running). Repositories do not know who will be notified in response to events.

## Subscriptions
Possibly in the repository, possibly as a separate store, subscription information is stored. This is logically separate but may be easiest to manage in the repository. Subscriptions map any notifiable object to a notification endpoint (such as an email address), possibly with wildcards.


## Notification

For HTTP notifications, PSHB updates are generated for the predictable feeds: e.g. one for the object itself, one for each container that the object is in, one for any aggregates the object is part of. The issue of doing updates for search results and the like is not addressed.


We probably also want to support HTTP webhooks and other extensions; they can be recorded in the subscriptions store and the repository hook that calls into the notification system would deliver them.


A dedicated daemon provides websocket streams for attached clients. This daemon is stateless and easily scaled - it just proxies websocket <-> PSHB, and the client will request appropriate feeds based on the HTTP UI telling it to do so.


For SMTP, a local repository hook delivers the new content notification to a SMTP handler, which then consults the subscription store to determine where to send the notification.


If deep history of notifications is needed or desired, it could live here.

### HTTP daemon
A lightweight HTTP daemon provides HTTP API services for multiple repositories and multiple subscription stores (typically all of both on a machine). On startup this daemon establishes PSHB subscriptions to remote repositories for all subscriptions held by the local repositories and checks for missed notifications. Once started the daemon will answer content requests from PSHB hubs as well as serving a browser UI. User authentication is handled here. This daemon is also stateless - several can be run in parallel for HA or performance.
###SMTP
Similar to HTTP, but probably no daemon at all - just a handle for procmail. Routes incoming notifications from subscribed SMTP-only systems (e.g. bugzilla) into a PSHB handler that will poll and update the replicated content appropriately.

## UI

### Browser UI
handlebars templates, RESTful API to the server, JSON representation of data. Atom feeds for most everything. Server side render static views for search engines. Websockets to notify clients of interesting events. New browser sessions will establish websocket subscriptions for everything the user is subscribed to, and ask for an initial push of interesting content.
### SMTP UI
Don’t know that we’ll bother beyond notifications (and thats not a certainty)... But if we do, it would be a responsibility for the incoming SMTP handler // SMTP notifier.
### CLI
Local client operations form the core of the system - and may perhaps even be the mechanism that the HTTP daemon builds on [keeping things very separated into clean layers].
Init a project
Add a symptom
Add a sign
Add a plan
Add a timeline event [subject, verb, date, details, url]
   - [‘Fix bug foo’, ‘committed’, ‘23rd March 2013’, ‘blah blah blah’, ‘https://github.com/foo/bar/commits/123’]
   - [‘symptom 54’, ‘observed’, ‘24th March 2013’, None, None]
   - [‘symptom 54’, ‘cannot reproduce’, ‘24th March, 2013’, None, Nne]


Query the timeline
Edit a sign/symptom/plan
Comment on a sign/symptom/plan/timeline event
Display an objectd'
[un]link plan->[aggregate] symptom/sign
Aggregate two symptoms
Aggregate two signs


________________
More stuff not sorted yet
See https://docs.google.com/a/robertcollins.net/document/d/1C26jwDc02XK5BRK7Hs_mhN3vbnCQBJhATlnCgQm13lY/edit and start at <lifeless>


[a]Martin Pool:
I understand this is more of a hypothesis about structure than about UI, and yet, I wonder if the thing can be really validated with no UI or a primitive UI.


What would a text-file simulation falsify about the product that could not be done from this document?
________________
robertc:
I find it hard to image the actual outcome of throwing a bug database through an automated pattern matcher. For instance.


We certainly have things to question about the UI etc.


The key thing for an MVP is 'at what point will people buy it' : I think the answer is 'when they have a need served by it'. For some early adopters that might be as simple as 'I can find dups well and mark up my original bug db from that'. For others it might be 'I can replicate offline'.
[b]Martin Pool:
+10, for the right value of 'dedicated'.  Totally separate interfaces may not work well.


People will wear multiple hats.


Especially for small projects they blur together.


People need to be guided to the right interface for the thing they're trying to achieve.


If it's possible for users to "cheat" by eg getting at the developer interface to get more attention their bug, they will.  Do you handle that by ACLs, or (I'd prefer) by addressing their concerns through the user side.
________________
robertc:
ACLs are a bit of a poor answer. I think a bit of column A bit of column B is the answer. Oh, and yes, the interfaces should be fluid, not partitioned.
[c]Martin Pool:
But it knows about timelines, releases, coordination of work, etc?


But I support the general idea of hooks over doing everything.
________________
robertc:
I think it needs to know about timelines to infer well. But I think it can consume timelines for most things rather than owning them as e.g. LP does. For instance, Causes doesn't need to do 'releases' like LP does - where you record changelogs metadata tarballs etc. Rather Causes needs to know whether to show a set of plans and symptoms by default - which isn't strictly tied to releases (its tied to versions users have, and to what a developer is doing...)
[d]Martin Pool:
I have mixed feelings about making this a tier 1 feature for a new product today.  I would probably trade it off for other things or for just getting working faster.


It is useful.  But on the other hand probably <1% of commits I ever made with bzr were done with no internet connection.


Internet connections are only going to get better and more ubiquitous.  Many planes have wifi; even at bad conferences there is usually 4G.


But perhaps offline mode connects to other things that are good in themselves, eg: structuring it internally as a stream of messages, or a good backup strategy, or federation, or ....  But it still probably has a cost.
________________
robertc:
Indeed! An earlier iteration said 'distributed/federation is not a compelling feature though everyone asks for the damn thing'. However, some of the things that I think are important - working with external sources of signs and symptoms, working in private [behind the firewall for company policy reasons], and degrading gracefully when other such services are offline - that all points to needing most/all of the bits to support effective offline support. So... I think rather than allowing it to be an adhoc feature lets do it well, which helps all the other bits mentioned above.
________________
Jelmer Vernooij:
One of the areas where federation/distributed is great is cooperation between upstreams/downstreams (e.g. Ubuntu's ability to track upstream bugs in Launchpad). This requires more than just being able to pull all changes from a remote tracker.
________________
robertc:
Can you be more specific about what it requires?
________________
Jelmer Vernooij:
The bug may have a different status  further upstream or downstream. It can not exist at all, because it's caused by a distribution-specific patch, or because it's a bug in the packaging, or it may be a bug that only occurs if it's built with compile-time options the package doesn't use.


A fork could decide that a particular feature request is valid, whereas the original project could may it WONTFIX and mark it as such, or vice versa.


Patches/workaround can be specific to individual instances of a bug. Priorities can be different.


So there are obviously lots of good reasons why a bug could have a different state upstream/downstream.


Even if you don't want to just blindly pull all changes from elsewhere it's probably useful to track what is happening in related/federated bug trackers - and use that information by displaying it to the user or using it during analysis.


That said, a lot of bugs do exist in the exact same form upstream and downstream. If you do a friendly fork of another project and regularly merge from them, you probably also want to just pull in all of their bug reports and the changes.
________________
robertc:
So lets analyze this in the frame of evidence about problems and proposed solutions.
________________
robertc:
Signs from just one distro (and that distro's downstreams) are perhaps distro caused. Evidence from multiple distinct sources is more likely to indicate an upstream problem. We may want to permit modelling a hierarchy of sources, even if we pull directly from them. E.g. Debian, Ubuntu, Mint.
________________
robertc:
Symptoms, which are your typical bugs, will often be things that should be signs, when dealing with other trackers. So that will be an issue. Likewise plan discussions will be pulled in as part of Symptom discussion when pulling from a flatter tracker. Maybe we just cope with that?
________________
robertc:
Plans - so I think the ideal with Plans is that downstreams discuss with upstream, and then if they are solving it differently, it's a different plan that they execute on.
________________
robertc:
All that said, I think this raises an interesting question. Do we have a convergent model, or a nonconvergent model for replication? Also and perhaps it's a separate dimension, what we federate vs replicate.


Consider someone behind the firewall but collaborating on select upstream bugs. They could just sign up with the upstream as an individual and have two separate systems. Thats undesirable because it silos the upstream data off from the private analysis. So we want to suck everything down, but filter what we push (only push things specifically selected as upstream relevant). A variant here - rather than presuming we can push; we might publish a filtered view of our data: that suggests that what we federate internally might become distributed there.


-> This leads me to suggest keeping it simple:


- we distribute, we don't federate except in exceptional cases: when there are foreign data sources, we suck them in entirely.


- where people are collaborating on one project, they should be pushing updates into the same repository


- where people are setting up a downstream/upstream relationship, it should be asymmetric; let the downstream choose what they push up stream (by setting up accounts etc), and if an upstream /wants/ to suck everything up, it's their choice


What do you think?
________________
Jelmer Vernooij:
(I'm finding it a bit tedious to discuss this in comments. Perhaps it's time to move this discussion into a section/doc?)
[e]Jelmer Vernooij:
Who is responsible for what data? Does causes pull in all external data (e.g. signs/symptoms) into its own data store? Does it just reference it? For what data is its data store authoritative?
________________
robertc:
This is a good question. Lets take a strong SOA approach and assume nothing is copied in except when selected for federation; we may need to bend that or introduce intermediary services if some sources don't index well. I"m not sure what authoritative means here though :)
[f]Jelmer Vernooij:
+1
[g]Jelmer Vernooij:
Dead link?
________________
robertc:
Apparently ;(
[h]Martin Pool:
We may disagree a bit on this, but I think: effort on bugs that never get done done is prima facie wasted, and this is something the tool should help avoid it.


There is value in communicating to/between users about bugs we can tell are not likely to be fixed, eg: a workaround, the fact it's low priority, the fact it's out of scope or against the projects' goals.


A different but related thing is encouraging developers to get things entirely finished once they're started.
________________
robertc:
I think we largely agree; but I see value in communication with users even on bugs that never get done. Lets keep an eye out for any friction that these different opinions cause in the design, and explicitly support both approaches.
[i]Jelmer Vernooij:
This can apply to storage, UI and processing?


It makes sense to apply separation to all three of those.
________________
robertc:
Yes, I think this is likely a pervasive separation up and down the stack.
[j]Jelmer Vernooij:
I agree that distribution bug tracking shouldn't be a priority.


That said, I'm not sure I understand how packages in a distribution are fundamentally different from upstream projects.
________________
robertc:
Offhand - scale (20K subprojects in one project); the intrinsic downstreamness.
