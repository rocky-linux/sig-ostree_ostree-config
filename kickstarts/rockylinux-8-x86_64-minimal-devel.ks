ostreesetup --nogpg --osname=rockylinux --remote=rockylinux --url=https://dl.rockylinux.org/pub/sig/8/ostree/x86_64/standard/ --ref=rockylinux/8/x86_64/minimal/devel

%post --erroronfail
rm -f /etc/ostree/remotes.d/rockylinux.conf
ostree remote add --no-gpg-verify rockylinux https://dl.rockylinux.org/pub/sig/8/ostree/x86_64/standard/
%end