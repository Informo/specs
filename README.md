# Informo specifications

[![https://specs.informo.network](https://img.shields.io/badge/specs-specs.informo.network-brightgreen.svg?style=flat-square)](https://specs.informo.network) [![FDL-1.3](https://img.shields.io/badge/license-FDL--1.3-blue.svg?style=flat-square)](/LICENSE) [![#discuss:weu.informo.network](https://img.shields.io/matrix/discuss:weu.informo.network.svg?server_fqdn=fr-02.nodes.informo.network&logo=matrix&style=flat-square)](https://matrix.to/#/#discuss:weu.informo.network) [![Open proposals](https://img.shields.io/badge/dynamic/json.svg?label=Open%20proposals&url=https%3A%2F%2Fstats.informo.network%2Fspecs%2Fproposals%3Fstate%3Dopen&query=%24.length&style=flat-square)](https://github.com/Informo/specs/pulls?q=is%3Apr+is%3Aopen) [![Merged proposals](https://img.shields.io/badge/dynamic/json.svg?label=Merged%20proposals&url=https%3A%2F%2Fstats.informo.network%2Fspecs%2Fproposals%3Fstate%3Dmerged&query=%24.length&&style=flat-square)](https://github.com/Informo/specs/pulls?utf8=%E2%9C%93&q=is%3Apr+is%3Aclosed)

Welcome to Informo's specifications repository. Informo's specifications aim at
giving a precise understanding of how Informo works.

A live version of the specifications generated from the source files in this
repository can be found at https://specs.informo.network/. This live version is
generated from the `master` branch, and is re-deployed each time new commits are
pushed to the said branch.

## Build the documentation

The specifications are built using [hugo](https://gohugo.io/), which you will
need to install before being able to build it.

When cloning this repository, make sure to initialise and update its submodules,
as the built version depends on an external theme which is referenced as a
submodule:

```
git clone https://github.com/Informo/specs --recurse-submodules
```

Then just run `hugo` at the root of the repository. It will generate a static
version of it in a `public` directory.

## Build the schemas

For the sake of simplicity, this documentation uses SVG schemas, located in
[/static/images](/static/images), in several locations. To make them render the
same way for every platform, text font is converted to svg paths.

A copy of the version with written text is available for each schema, with its
name ending with `.src.svg`. After modifying one of those, text must be
converted to paths again, by running `./svg-fonts-to-path.sh` from the root of
the repository. The script uses [Inkscape](https://inkscape.org/), which must be
installed on the system before generating the new versions of the schemas.

The schemas have been initially generated on a GNU/Linux system using the "Sans"
system font. In order to get a similar result, it is advised to perform any
generation on a similar system.

## Contribute

Contributions to the Informo specifications are welcome. These must follow
Informo's [Specifications Changes Submission
Protocol](https://specs.informo.network/introduction/scsp/).

While working on a submission, using hugo's watcher might be easier than
manually running `hugo` each time you make a change:

```
hugo server
```

This command must be run from the root of the repository. Hugo will start a
webserver on `http://127.0.0.1:1313` (unless instructed otherwise), and rebuild
(and reload) the site on every change.

## Get in touch

Whether it is to get to know Informo, to look for a way to contribute, or for
any other reason, anyone is welcome to join the discussion and overall chatter
in our [Matrix room](https://matrix.to/#/#discuss:weu.informo.network) or our
[IRC channel](http://webchat.freenode.net?channels=%23informo).

You can also reach the Informo core team in a more private way by sending an
email to <core@informo.network>.
