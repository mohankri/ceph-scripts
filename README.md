# ceph-scripts
This script is do all the necessary prerequisites for doing a private build of ceph.
It download the tarball, extract and install all the dependencies needed and modifies the script accordingly.


Troubleshooting
===============
Before doing any manual operation make sure LD_LIBRARY_PATH is set to /usr/local/lib

If OSD not coming up
====================
check if ceph-osd process is running or not
check if /var/lib/ceph/osd exists or not

if not
sudo  mkdir /var/lib/ceph/osd

ceph-deploy disk zap ceph1:sdb
ceph-deploy osd prepare ceph1:sdb
ceph-deploy osd activate ceph1:sdb1

and restart the ceph-osd process manually

ceph-osd -i 0

