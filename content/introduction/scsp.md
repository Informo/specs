---
title: "Specifications change submission protocol"
weight: 2
---

This page describes the protocol followed regarding the submission of any change of this documentation (also named "Specifications changes submission", shortened as "SCS"). This protocol is named "Specifications change submission protocol" (which can be shortened to "SCSP").

Any SCS **must** be done by opening a [pull request](https://help.github.com/articles/about-pull-requests/) against the specifications' GitHub repository (located [here](https://github.com/Informo/specs)). This can be done by either creating a fork of the repository and opening a pull request, or using the "Edit this page" button located on the top right corner of every page. The pull request's initial comment **must** include a brief description of the changes involved in this SCS, and a description of the issue it addresses. If the SCS addresses an issue that's already the target of an issue on the GitHub repository, the pull request's initial comment **must** also mention it.

Once a pull request is open, a member of the [Informo core team](/informo/informo-core-team) will tag it using labels describing the type of the changes submitted and the stage the SCS is in (if it includes a change in behaviour). The Informo core team members are volunteers, and most of them have an occupation besides working on Informo-related projects, which means your submission might not be tagged as soon as you send it. Please keep that in mind when submitting your changes, and wait at least a week before complaining (politely) about it in our [discussions room](https://matrix.to/#/#discuss:weu.informo.network).

If you are unsure about whether changes should be made regarding a specific part of the specifications, or about whether you would have the time and/or resources to issue a SCS, feel free to discuss it with us by either [opening an issue](https://github.com/Informo/specs/issues/new) or joining our discussion room.

Below are described the different types of changes and the steps a submission matching one of them has to go through before being merged to this documentation.

## Typo, wording and phrasing

A SCS fixing one or more spelling mistakes, or fixing bad wording and/or phrasing without altering any behaviour described by the specifications (nor adding any new one), **must** be tagged with the `type:typo` label.

On top of that, it **must** be tagged with only one label describing its state, which **must** be one of:

* `scsp:pending`: this SCS is pending review.
* `scsp:review`: a review of this SCS is underway by one of the Informo core team members. The review process for this type of SCS is described below.
* `scsp:merged`: the SCS has been accepted and the pull request has been merged.
* `scsp:won't merge`: the reviewer decided this SCS isn't fit for merging, and **must** justify their decision before closing the pull request.

The order of the tags as described above **should** (but might not, according to the situation) be representative of the SCS's life cycle.

### Review process

The review process starts with an initial review of the pull request by the Informo core team member using GitHub's review engine, during which the reviewer points out issues to address before the SCS can be accepted, and ends when an agreement on the changes to make is found between the reviewer and the SCS submitter.

## Behaviour change

A SCS that's either adding a new behaviour to the specification or changing or removing an existing behaviour **must** be tagged with the `type:behaviour` label.

On top of that, it **must** be tagged with only one label describing its state, which **must** be one of:

* `scsp:wip`: this SCS is a work in progress. This label can either be added by the pull request's author given they have sufficient rights to the repository, or following a request issued from the SCS's author to the Informo core team (either in the pull request's initial comment or in the discussions room).
* `scsp:review`: this SCS is ready for review. The review process for this type of SCS is described below.
* `scsp:final review`: a final review of the SCS is underway by one of the Informo core team members. This step is optional and the SCS **must** only go through it if one or more of the Informo core team members strongly disagrees with the current state of the SCS. The review process is the same as the standard review process for a SCS tagged `type:typo`, and is described in the paragraph above.
* `scsp:merged`: the SCS has been accepted and the pull request has been merged.
* `scsp:won't merge`: an Informo core team member decided this SCS isn't fit for merging, and **must** justify their decision before closing the pull request.

The order of the tags as described above **should** (but might not, according to the situation) be representative of the SCS's life cycle.

### Review process

The review process starts as soon as the `scsp:review` label is added to the SCS's pull request. From then on, the SCS is available for public review for a total of 14 days (two weeks) 👀. During this period, anyone **can** issue a review on the SCS or comment and discuss it, preferably in the pull request's comments.
