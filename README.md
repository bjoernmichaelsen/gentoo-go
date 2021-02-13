[![CircleCI](https://circleci.com/gh/bjoernmichaelsen/gentoo-go.svg?style=svg)](https://app.circleci.com/pipelines/github/bjoernmichaelsen/gentoo-go)


# gentoo-go
little helper to build and add go to a gentoo stage3 tarball

## Is this in any way an "official gentoo go image"?

no.

## why all this tooling?

golang does not seem to like being build docker-in-docker -- it need to build
in a priviledged run. This mini repo provides the tooling to do that: It takes
a gentoo stage3 tarball and builds the most recent version of go on top of
it.

## why bother at all as there are official golang docker images?

[Reflections on trusting trust](http://users.ece.cmu.edu/~ganger/712.fall02/papers/p761-thompson.pdfhttp://users.ece.cmu.edu/~ganger/712.fall02/papers/p761-thompson.pdf)
teaches us not to not trust binaries unconditionally. The intend is to provide
a way to bootstrap the toolchain for go independant of the official golang binaries.
This will not help against maliciuos code in the golang or gentoo source
itself, but might one day help detect malicious code injected in the toolchain
in those binaries. This is not to say these images are in any what "better"
than the official ones. But if you are sufficiently paranoid, you can use these
images to build and compare with an build from the official image of the same
version and verify the result is the same.

## Is there any other benefit to these images?

You get a gentoo userspace that is ready to go. If you for any reason prefer
that for your usecase over the Debian base of the "official" golang images, you
are invited to take advantage of that.

## Where are the images produced by this?

The images can be found at https://hub.docker.com/r/bjoernmichaelsen/gentoo-go.

## how can I use this locally?

If you want to build the image locally, have a recent versions of GNU make,
coreutils and docker installed. Then execute:

    make

and it should build and tag you a stage3 tarball with an additional go
pre-installed.

## how big is the image?

At the time of writing, the stage3 tarball is 1.2GB. go currently adds some
400MB to that. Some 300MB are added by updating with (before building):

   emerge --sync

As go builds static binaries, nothing from the build image will be deployed in
most cases, so the layers have been left intact as keeping the history intact
is considered more important.

## Why this license?

The closest upstream of this are gentoos ebuild. Lacking a reason the divert from
them I used GPLv3 for the tooling here too.
