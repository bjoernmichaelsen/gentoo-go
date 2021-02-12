gentoo-go: gentoo-go-prep
	docker run --privileged --cidfile gentoo-go.cid gentoo-go-prep /emerge-go
	docker commit `cat gentoo-go.cid` gentoo-go:1.15

gentoo-go-prep:
	docker build -f Dockerfile.prep -t gentoo-go-prep .

