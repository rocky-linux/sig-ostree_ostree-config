# dnf-groups
These manifest files are organized so that each file represents a DNF group and lists the packages from that group. 
This may seem unnecessary, and in the end it doesn't really matter, but when thinking about rocky ostree in terms of 
a rocky minimal clone it is helpful.  Note that at the moment only mandatory and default packages from these groups are 
included.

### Note About Excluded Packages
You will notice that a handful packages are commented out.  Some of which have corresponding comments that explain why 
they are excluded. If something is excluded without a comment it was most likely because it fell into the category of 
"when its included rpm-ostree freaks out or the produced build is broken". In some cases these packages should be 
included and warrant further investigation, however, others will probably be left out in the end regardless.

