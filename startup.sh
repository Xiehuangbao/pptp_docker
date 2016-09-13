#!/bin/bash

#ip_forward_should="net.ipv4.ip_forward=1"
ip_forward_state=`grep -v '^#' /etc/sysctl.conf | grep -v '^$' | grep "net.ipv4.ip_forward"`
if [ "$ip_forward_state" = "" ]
then
	echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
	sysctl -p
	echo "ip_forward turn on"
fi

iptables_rule1=`iptables -t nat -L POSTROUTING | grep "192.168.0.0/24"`
iptables_rule2=`iptables -L FORWARD | grep "192.168.0.0/24"`
if [ "$iptables_rule1" = "" ]
then
	iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o eth0 -j MASQUERADE
fi

if [ "$iptables_rule2" = "" ]
then
	iptables -A FORWARD -s 192.168.0.0/24 -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1200
fi

#iptable-restore=`grep "iptables-restore" /etc/network/interfaces`
#iptables-save > /etc/iptables-rules
#if [ "$iptable-restore" = "" ]
#then
#	echo "pre-up iptables-restore < /etc/iptables-rules" >> /etc/network/interfaces
#fi

#touch /var/log/ppp.log

#syslog='grep "/var/log/ppp.log" /etc/rsyslog.d/50-default.conf'
#if [ "$syslog" = "" ]
#then 
#	echo "demo.*	/var/log/ppp.log"
#	/etc/init.d/rsyslog restart
#fi

service pptpd restart
ifstat -STt
#tail -f /var/log/ppp.log
