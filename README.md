[![CircleCI](https://circleci.com/gh/bjoernmichaelsen/gentoo-go.svg?style=svg)](https://app.circleci.com/pipelines/github/bjoernmichaelsen/gentoo-go)


# gentoo-go
little helper to build and add go to a gentoo stage3 tarball

## why?

golang does not seem to like being build docker-in-docker -- it need to build
in a priviledged run. This mini repo provides the tooling to do that: It takes
a gentoo stage3 tarball and builds the most recent version of go on top of
it.

## Is this in any way an "official gentoo go image"?

no.

## Where are the images?

The images can be found at https://hub.docker.com/r/bjoernmichaelsen/gentoo-go.

## how?

If you want to build the image locally, have a recent versions of GNU make,
coreutils and docker installed. Then execute:

    make

and it should build and tag you a stage3 tarball with an additional go
pre-installed.

## how big is the image?

At the time of writing, the stage3 tarball is 1.2GB. go currently adds some
800MB to that. Some 300MB are added by updating with (before building):

   emerge --sync

Those can likely be squashed away, e.g. by copying in the contents of the image
in an scratch image. As go builds static binaries, nothing from the build image
will be deployed in most cases, so the layers have been left intact as keeping
the history intact is considered more important.

## Why this license?

The closest upstream of this are gentoos ebuild. Lacking reason the divert from
them I used GPLv3 too here.
