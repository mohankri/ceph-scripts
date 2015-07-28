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

ceph@ceph8:/home/ceph$ gcc -o cephclient cephclient.c -lrados


Micro-OSD
=========
$ time bash micro-osd.sh single-osd
$ export CEPH_ARGS='--conf single-osd/ceph.conf'

$ du -sh single-osd/
103M    single-osd/

Cluster Configuration

[global]
fsid = $(uuidgen)
osd crush chooseleaf type = 0
run dir = ${DIR}/run
auth cluster required = none
auth service required = none
auth client required = none

MON configuration

[mon.0]
log file = ${DIR}/log/mon.log
chdir = ""
mon cluster log file = ${DIR}/log/mon-cluster.log
mon data = ${MON_DATA}
mon addr = 127.0.0.1

$ ceph-mon --id 0 --mkfs --keyring /dev/null

$ ceph-mon --id 0

OSD configuration

[osd.0]
log file = ${DIR}/log/osd.log
chdir = ""
osd data = ${OSD_DATA}
osd journal = ${OSD_DATA}.journal
osd journal size = 100

ceph osd pool set data size 1
