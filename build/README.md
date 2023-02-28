## How to Build

### Notes on Building
- At the moment this config is built manually using the commands below.  The end goal will be to incorporate this
into [Empanadas](https://github.com/rocky-linux/sig-core-toolkit).  That being said the build tools provided here should
be considered a proof of concept at best, and will most likely be removed in the future.
- Depending on your setup, you may need to run the following commands as root.

### Tree & ISO
```
make
```
Composes an ostree commit based on the current config, updates the local repo, then creates an installation ISO which embeds the
local repo.  For more control continue reading.

### Tree Composition
```
make init
```
Sanitizes the build env and creates an empty ostree repo.  This step is only needed if you want to start
fresh. If you wish to build commits on top of existing rocky ostree create a mirror. See `make mirror`.

```
make mirror
```
Sanitizes the build env and mirror the ostree from the rockylinux.org remote. This is useful when you want a known working
starting point to commit on top of.

```
make tree
```
Composes a new tree commit based on the current manifest(s).  At the moment, this is hardcoded to compose `../manifest.8-minimal.yaml`.

### Installer ISO
```
make iso
```
Creates an installation ISO of the current local tree in `./repo`.

#### Notes
1. The resulting ISO embeds the newest tree commit (depth 0). Currently, this is hardcoded to the `.../minimal/devel` ref.
2. The resulting ISO is a standard anaconda installer which will require the user to config users, network, etc. The "special sauce"
   is the embedded kickstart file that calls `ostreesetup ...`. See `/lorax-templates/lorax-configure-repo.tmpl` or `kickstarts/rockylinux-8-x86_64-minimal-devel.ks` .

### Host Local Repo Server
```
make test-server
```
Deploys a nginx container to host `./repo` for testing purposes. 

Note that you will need to manually add a remote to your ostree installation for this test server. This can be done like so:
```
ostree remote add --no-gpg-verify test-server http://your.ip.address.here:9001/
```

From there you can rebase your installation to the test server like so:
```
rpm-ostree rebase --remote test-server -b rockylinux/8/x86_64/minimal/devel
```