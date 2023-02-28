RELEASE_VER_MAJOR = 8
RELEASE_VER_MINOR = 7
ARCH = $(shell uname -m)
RELEASE_NAME = rocky-linux-ostree-$(ARCH)-$(RELEASE_VER_MAJOR).$(RELEASE_VER_MINOR)
DEFAULT_OSTREE_REMOTE = https://dl.rockylinux.org/pub/sig/$(RELEASE_VER_MAJOR)/ostree/$(ARCH)/standard/
MOCK_CONFIG = rocky-$(RELEASE_VER_MAJOR)-$(ARCH)


.PHONY: all
all: init tree iso

.PHONY: clean
clean:
	rm -rf ./repo ./cache

.PHONY: init
init: clean
	mkdir -p ./{repo,cache,images}
	ostree --repo=./repo init --mode=archive

.PHONY: mirror
mirror: init
	ostree --repo=./repo remote add rockylinux --set=gpg-verify=false $(DEFAULT_OSTREE_REMOTE) && \
	ostree --repo=./repo pull --mirror rockylinux rockylinux/$(RELEASE_VER_MAJOR)/$(ARCH)/minimal/devel && \
    ostree --repo=./repo summary --update

.PHONY: tree
tree:
	rpm-ostree compose tree --repo=./repo --cachedir=./cache --unified-core ../manifest.8-minimal.yaml && \
	ostree summary --repo=./repo --update

.PHONY: iso
iso:
	mock -r $(MOCK_CONFIG) --clean
	mock -r $(MOCK_CONFIG) --init
	mock -r $(MOCK_CONFIG) --install lorax ostree
	mock -r $(MOCK_CONFIG) --copyin $$(pwd)/repo /builddir/repo
	mock -r $(MOCK_CONFIG) --copyin $$(pwd)/lorax-templates /builddir/lorax-templates
	mock -r $(MOCK_CONFIG) --enable-network --chroot "cd /builddir && \
	    lorax --product='Rocky Linux OSTree' \
		--version=$(RELEASE_VER_MAJOR) \
		--release=$$(date +%Y%m%d) \
		--variant=R$(RELEASE_VER_MAJOR) \
		--skip-branding \
		--installpkgs rocky-release* \
		--installpkgs rocky-logos-$(RELEASE_VER_MAJOR)* \
		--installpkgs ostree* \
		--source=https://dl.rockylinux.org/pub/rocky/$(RELEASE_VER_MAJOR)/BaseOS/$(ARCH)/os/ \
		--source=https://dl.rockylinux.org/pub/rocky/$(RELEASE_VER_MAJOR)/AppStream/$(ARCH)/os/ \
		--nomacboot \
		--volid=$(RELEASE_NAME) \
		--add-template=/builddir/lorax-templates/lorax-configure-repo.tmpl \
		--add-template=/builddir/lorax-templates/lorax-embed-repo.tmpl \
		--add-template-var=ostree_install_repo=file:///builddir/repo \
		--add-template-var=remote_url=$(DEFAULT_OSTREE_REMOTE) \
		--add-template-var=default_ref=rockylinux/$(RELEASE_VER_MAJOR)/$(ARCH)/minimal/devel \
		--logfile=/builddir/lorax.log \
		--tmp=/builddir/tmp \
		--rootfs-size=8 \
		/builddir/completed-iso"
	mock -r $(MOCK_CONFIG) --copyout /builddir/completed-iso/images/boot.iso $$(pwd)/images/$(RELEASE_NAME).iso


.PHONY: test-server
test-server:
	podman stop ostree-test-server --ignore && \
	podman rm ostree-test-server --ignore && \
	podman run -d \
		--name=ostree-test-server \
		-p 9001:80 \
		-v ./repo:/usr/share/nginx/repo \
		-v ./nginx.conf:/etc/nginx/nginx.conf \
		--security-opt label=disable \
		nginx

