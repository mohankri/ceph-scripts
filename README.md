# ceph-scripts
This script is do all the necessary prerequisites for doing a private build of ceph.
It download the tarball, extract and install all the dependencies needed and modifies the script accordingly.


Troubleshooting
===============
Before doing any manual operation make sure LD_LIBRARY_PATH is set to /usr/local/lib

If OSD not coming up
====================
Verify if ceph-osd process is running or not and directory /var/lib/ceph/osd exists or not

if not
sudo  mkdir /var/lib/ceph/osd

ceph-deploy disk zap ceph1:sdb

ceph-deploy osd prepare ceph1:sdb

ceph-deploy osd activate ceph1:sdb1

and restart the ceph-osd process manually

ceph-osd -i 0

Build CEPH Client on other host
===============================
ceph@ceph8:/etc/ceph$ cat ceph.conf 
[global]
mon_host = ceph1,ceph3,ceph7
keyring = /etc/ceph/ceph.client.admin.keyring

copy ceph.client.admin.keyring /etc/ceph directory from the node running ceph-mon

ceph@ceph8:/home/ceph$ gcc -o cephclient cephclient.c -lrado


