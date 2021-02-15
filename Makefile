BUILD_DATE:=$(shell date -I)
DOCKERID:=bjoernmichaelsen
IMAGE_REPO:=$(DOCKERID)/gentoo-go
IMAGE_TAG:=nightly-$(BUILD_DATE)

metadata: environment.bz2 Manifest smoketest
	@true

smoketest:| gentoo-go
	docker build . -f Dockerfile.smoketest -t $(DOCKERID)/gentoo-go-smoketest
	docker run $(DOCKERID)/gentoo-go-smoketest | tee $@

environment.bz2:| gentoo-go
	docker run bjoernmichaelsen/gentoo-go /bin/sh -c 'cat `find /var/db/pkg/dev-lang/ -name $@ |grep go`' > $@

Manifest:| gentoo-go
	docker run $(IMAGE_REPO):$(IMAGE_TAG) cat /var/db/repos/gentoo/Manifest > Manifest

gentoo-go: gentoo-go-prep
	docker run --privileged --cidfile gentoo-go.cid gentoo-go-prep /emerge-go
	docker commit `cat gentoo-go.cid` $(IMAGE_REPO):$(IMAGE_TAG)
	docker tag $(IMAGE_REPO):$(IMAGE_TAG) $(IMAGE_REPO):latest
	rm gentoo-go.cid

gentoo-go-prep:
	docker build -f Dockerfile.prep -t gentoo-go-prep .

clean:
	rm -f Manifest gentoo-go.cid environment.bz2 smoketest

push-image:
	echo "$${REGISTRY_PASSWORD}" | docker login --username "$${REGISTRY_USERNAME}" --password-stdin
	docker push $(IMAGE_REPO)

.PHONY: metadata gentoo-go gentoo-go-prep clean push-image
