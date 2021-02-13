BUILD_DATE=$(shell date -I)
IMAGE=bjoernmichaelsen/gentoo-go
IMAGE_TAG=nightly-$(BUILD_DATE)

metadata: environment.bz2 Manifest
	true

environment.bz2: gentoo-go
	cat `find /var/db/pkg/dev-lang/ -name environment.bz2 |grep go |grep -v bootstrap` > $@

Manifest: gentoo-go
	docker run $(IMAGE):$(IMAGE_TAG) cat /var/db/repos/gentoo/Manifest > Manifest

gentoo-go: gentoo-go-prep
	docker run --privileged --cidfile gentoo-go.cid gentoo-go-prep /emerge-go
	docker commit `cat gentoo-go.cid` $(IMAGE):$(IMAGE_TAG)
	docker tag $(IMAGE):$(IMAGE_TAG) $(IMAGE):latest
	rm gentoo-go.cid

gentoo-go-prep:
	docker build -f Dockerfile.prep -t gentoo-go-prep .

clean:
	rm -f Manifest gentoo-go.cid environment.bz2

push-image:
	echo "$${REGISTRY_PASSWORD}" | docker login --username "$${REGISTRY_USERNAME}" --password-stdin
	docker push $(IMAGE)

.PHONY: metadata gentoo-go gentoo-go-prep clean push-image
