BUILDDIR?=./build
BUILD_DATE:=$(shell date -I)
DOCKERID:=bjoernmichaelsen
IMAGE_REPO:=$(DOCKERID)/gentoo-go
IMAGE_TAG:=nightly-$(BUILD_DATE)
FEATURES:="-sandbox -ipc-sandbox -network-sandbox -pid-sandbox"
MAKEOPTS:="-j3"

all: $(BUILDDIR)/environment.bz2 $(BUILDDIR)/Manifest $(BUILDDIR)/smoketest
	@true

$(BUILDDIR)/smoketest: $(BUILDDIR)/gentoo-go.cid
	docker build . -f Dockerfile.smoketest -t $(DOCKERID)/gentoo-go-smoketest
	docker run --rm $(DOCKERID)/gentoo-go-smoketest | tee $@

$(BUILDDIR)/environment.bz2: $(BUILDDIR)/gentoo-go.cid
	docker run --rm bjoernmichaelsen/gentoo-go /bin/sh -c 'cat `find /var/db/pkg/dev-lang/ -name $@ |grep go`' > $@

$(BUILDDIR)/Manifest: $(BUILDDIR)/gentoo-go.cid
	docker run --rm $(IMAGE_REPO):$(IMAGE_TAG) cat /var/db/repos/gentoo/Manifest > $@

$(BUILDDIR)/gentoo-go.cid: gentoo-go-prep $(BUILDDIR)/.dir
	docker run --privileged --cidfile $@ --env FEATURES=$(FEATURES) --env MAKEOPTS=$(MAKEOPTS) gentoo-go-prep sh -c 'emerge dev-lang/go dev-vcs/git && emerge --unmerge go-bootstrap && rm -rf /var/cache/distfiles/*'
	docker commit `cat $@` $(IMAGE_REPO):$(IMAGE_TAG)
	docker tag $(IMAGE_REPO):$(IMAGE_TAG) $(IMAGE_REPO):latest
	docker tag $(IMAGE_REPO):$(IMAGE_TAG) $(IMAGE_REPO):`docker run $(IMAGE_REPO):$(IMAGE_TAG) sh -c "go version|cut -f3 -d\ "`
	docker container rm `cat $@`

$(BUILDDIR)/.dir:
	mkdir -p $(BUILDDIR)
	touch $@

gentoo-go-prep:
	docker build -f Dockerfile.prep -t gentoo-go-prep .

clean:
	rm -f $(BUILDDIR)/Manifest $(BUILDDIR)/gentoo-go.cid $(BUILDDIR)/environment.bz2 $(BUILDDIR)/smoketest $(BUILDDIR)/.dir

push-image:
	echo "$${REGISTRY_PASSWORD}" | docker login --username "$${REGISTRY_USERNAME}" --password-stdin
	docker push $(IMAGE_REPO)

.PHONY: all gentoo-go-prep clean push-image
