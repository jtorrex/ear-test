#!/bin/bash

# EAR locations

EARINSTALLPATH="$HOME/ear/bin"
MYSQLPATH="/usr/include/mysql/"
EARTMPPATH="/var/ear"
EARETCPATH="/etc/ear"
CCOMPILERPATH="/usr/bin/gcc"
MPICOMPILERPATH="/usr/lib64/openmpi/bin/mpicc"
##GSLPATH=""
##PAPIPATH=""
##$CFLAGSCOMPILER="DUMMY"
##$MPIFLAGS="DUMMY"
##$PATHTOCUDA="DUMMY"
USER="root"
GROUP="root"

mkdir -p $EARINSTALLPATH
mkdir -p $EARTMPPATH
mkdir -p $EARETCPATH

# Dependencies

yum makecache --refresh

yum -y groupinstall "Development Tools"

yum -y install papi
yum -y install gsl
yum -y install kernel-tools
yum -y install freeipmi
yum -y install openmpi
yum -y install mariadb
yum -y install mariadb-devel

# Start MariaDB

systemctl enable mariadb && systemctl start mariadb &&  systemctl status mariadb

# EAR installation

./configure --prefix=$EARINSTALLPATH \
	--with-mysql=$MYSQLPATH \
	EART_TMP=$EARTMPPATH \
	EAR_ETC=$EARETCPATH \
	CC=$CCOMPILERPATH \
	MPICC=$MPICOMPILERPATH \
	USER=$USER \
	GROUP=$GROUP \
	##CC_FLAGS=$CFLAGSCOMPILER \
	##MPICC_FLAGS=$MPIFLAGS \
	##--with-cuda=$PATHTOCUDA

make
make install
make doc.install
make etc.install
