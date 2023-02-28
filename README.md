# Rocky Linux OSTree

This repository contains the configuration files needed to spin Rocky Linux using rpm-ostree.

## Project Structure
- `manifest.$releasever-$rltype.yaml` - These files represent the entry point for a given release config.
- `manifests/rocky-common.yaml` - Default configuration for rpm-ostree and rocky common to all variants.
- `manifests/arch` - These files contain configuration specific to the named architecture, x86_64, aarch64, aarch64-pi. Note these should be explicitly included by top level manifests.
- `manifests/dnf-groups` - Contains lists of packages organized by containing dnf group, e.g., @Core, @Standard, etc.  This is not a comprehensive list and my not be the best approach.
- `build` - Contains instructions and scripts to build both the server-side tree and an installation ISO. See the `build/README.md` for build instructions.
- `kickstarts` - Anaconda kickstart files that can be used with any anaconda installer image.

For details on these manifests, A.K.A. Treefiles, see: [Treefile Reference](https://coreos.github.io/rpm-ostree/treefile/) 



