BUILD_DATE=$(shell date -I)
IMAGE=bjoernmichaelsen/gentoo-go:nightly-$(BUILD_DATE)

Manifest: gentoo-go
	docker run $(IMAGE) cat /var/db/repos/gentoo/Manifest > Manifest

gentoo-go: gentoo-go-prep
	docker run --privileged --cidfile gentoo-go.cid gentoo-go-prep /emerge-go
	docker commit `cat gentoo-go.cid` $(IMAGE)
	rm gentoo-go.cid

gentoo-go-prep:
	docker build -f Dockerfile.prep -t gentoo-go-prep .

clean:
	rm -f Manifest gentoo-go.cid

.PHONY: gentoo-go gentoo-go-prep clean
