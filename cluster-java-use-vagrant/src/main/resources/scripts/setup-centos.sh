#!/bin/bash
source "/vagrant/scripts/common.sh"

function disableFirewall {
	echo "disabling firewall"
	service iptables save
	service iptables stop
	chkconfig iptables off
}

echo "setup centos"

yum -y install wget
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS6-Base-163.repo
yum makecache
yum -y update
yum -y install gcc openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel gcc-c++ automake autoconf
yum -y install ruby rubygems

gem sources --add https://ruby.taobao.org/ --remove https://rubygems.org/
gem install redis --version 3.0.5

yum -y install nano vim tcl lsof prelink expect

disableFirewall