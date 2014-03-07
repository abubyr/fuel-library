#!/bin/sh -x
NODE=$1
case $NODE in
    1)
       ip_eth0='10.20.0.136'
       ip_eth1='172.18.12.118'
       netmask_eth0='255.255.255.0'
       netmask_eth1='255.255.255.0'
       ;;
    2)
       ip_eth0='10.20.0.137'
       ip_eth1='172.18.12.119'
       netmask_eth0='255.255.255.0'
       netmask_eth1='255.255.255.0'
       ;;
    3)
       ip_eth0='10.20.0.138'
       ip_eth1='172.18.12.120'
       netmask_eth0='255.255.255.0'
       netmask_eth1='255.255.255.0'
       ;;
    *)
       echo "Invalid node number. You should use 1, 2 or 3."
       exit 1
       ;;
esac

cat > /etc/sysconfig/network <<HOSTNAME_SET
NETWORKING=yes
HOSTNAME=node-$NODE.domain.tld
GATEWAY=10.20.0.2
HOSTNAME_SET

cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<IFCFG_ETH0
DEVICE=eth0
IPADDR=$ip_eth0
NETMASK=$netmask_eth0
BOOTPROTO=none
ONBOOT=yes
USERCTL=no
IFCFG_ETH0

cat > /etc/sysconfig/network-scripts/ifcfg-eth1 <<IFCFG_ETH1
DEVICE=eth1
IPADDR=$ip_eth1
NETMASK=$netmask_eth1
BOOTPROTO=none
ONBOOT=yes
USERCTL=no
IFCFG_ETH1

cat > /etc/hosts <<HOSTS_SET
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.20.0.136 node-1.domain.tld
10.20.0.137 node-2.domain.tld
10.20.0.138 node-3.domain.tld
HOSTS_SET

/etc/init.d/network restart
