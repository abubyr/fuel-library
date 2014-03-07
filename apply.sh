#!/bin/sh -x
NODE=$1
PUPPET_MODULES='/etc/puppet/modules'
PUPPET_MANIFESTS='/etc/puppet/manifests'
PRIMARY_MONGO=0

if [ $NODE -eq 3 ]; then
    PRIMARY_MONGO=1
fi

#yum -y install git
#rm -rf "fuel_library"
#git clone https://github.com/abubyr/fuel-library/
#cd fuel-library

git checkout us40-us43-1st-deliver

if [ -d $PUPPET_MODULES ]; then
    rm -rf $PUPPET_MODULES/*
else
    mkdir -p $PUPPET_MODULES
fi

if [ ! -d $PUPPET_MANIFESTS ]; then
    mkdir -p $PUPPET_MANIFESTS
fi

cp -af deployment/puppet/* $PUPPET_MODULES
cp -af *.pp $PUPPET_MANIFESTS
cp -af astute.yaml /etc/
cd ..

if [ PRIMARY_MONGO -eq 1 ]; then
    puppet apply --logdest /root/primary_mongo.pp.log --verbose --debug --trace "${PUPPET_MANIFESTS}/primary_mongo.pp"
    sleep 120
    puppet apply --logdest /root/ceilometer.pp.log --verbose --debug --trace "${PUPPET_MANIFESTS}/ceilometer.pp"
else
    puppet apply --logdest /root/secondary_mongo.pp.log --verbose --debug --trace "${PUPPET_MANIFESTS}/secondary_mongo.pp"
fi
