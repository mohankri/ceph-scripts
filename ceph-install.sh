#!/bin/bash

CEPH_URL=http://ceph.com/download
CEPH_VER=ceph-0.94.2
TARBALL=$CEPH_VER.tar

download_ceph()
{
	wget $CEPH_URL/$TARBALL.gz
	gunzip $TARBALL.gz
	tar xvf $TARBALL
}

download_dependencies()
{
	sudo apt-get -y install autotools-dev autoconf automake cdbs gcc g++ git libboost-dev libedit-dev libssl-dev libtool libfcgi libfcgi-dev libfuse-dev linux-kernel-headers libcrypto++-dev libcrypto++ libexpat1-dev
	sudo apt-get -y install uuid-dev libkeyutils-dev libgoogle-perftools-dev libatomic-ops-dev libaio-dev libgdata-common libgdata13 libsnappy-dev libleveldb-dev
	sudo apt-get -y install libblkid-dev libudev-dev xfslibs-dev libboost-all-dev gdisk	
	sudo apt-get -y install debhelper dpkg-buildpackage
	
}

remove_dependencies()
{
	sudo apt-get  -y remove autotools-dev autoconf automake cdbs gcc g++ git libboost-dev libedit-dev libssl-dev libtool libfcgi libfcgi-dev libfuse-dev linux-kernel-headers libcrypto++-dev libcrypto++ libexpat1-dev
	sudo apt-get  -y remove uuid-dev libkeyutils-dev libgoogle-perftools-dev libatomic-ops-dev libaio-dev libgdata-common libgdata13 libsnappy-dev libleveldb-dev
	sudo apt-get -y remove libblkid-dev libudev-dev xfslibs-dev libboost-all-dev gdisk	
	sudo apt-get -y remove debhelper dpkg-buildpackage

}

build_ceph()
{
	cd $CEPH_VER
	./install-deps.sh
	./autogen.sh
	./configure
	sudo make 
	sudo make install
	cd ../
}

install_ceph_script()
{
	sudo cp ${CEPH_VER}/src/init-ceph /etc/init.d/ceph
	sudo cp ${CEPH_VER}/src/init-radosgw /etc/init.d/radosgw
	sudo cp ${CEPH_VER}/src/upstart/* /etc/init/
	sudo chmod 755 /etc/init.d/radosgw
	sudo cp ${CEPH_VER}/udev/* /lib/udev/rules.d
}

update_ceph_script()
{
	sudo sed -i s/sbin/"local\/sbin"/ /etc/init/ceph-create-keys.conf
	sudo sed -i s/bin/"local\/bin"/g /etc/init/ceph-mds.conf
	sudo sed -i s/bin/"local\/bin"/g /etc/init/ceph-mon.conf
	sudo sed -i s/bin/"local\/bin"/g /etc/init/ceph-osd.conf
	sudo sed -i s/"ETCDIR=\/usr\/local\/etc\/ceph"/"ETCDIR=\/etc\/ceph"/ /etc/init.d/ceph
}

download_ceph
#remove_dependencies
download_dependencies

build_ceph
install_ceph_script
update_ceph_script

