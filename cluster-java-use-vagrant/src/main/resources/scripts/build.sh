#!/usr/bin/env bash
# 更换阿里云源
#mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
#wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS6-Base-163.repo
yum -y update
yum -y install nano vim gcc tcl lsof

# 安装redis
wget http://download.redis.io/releases/redis-3.0.5.tar.gz
tar xzf redis-3.0.5.tar.gz
cd redis-3.0.5
make
make install
cd utils
chmod +x install_server.sh
./install_server.sh
service redis_6379 status
service redis_6379 start

wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u65-b17/jdk-8u65-linux-x64.rpm
rpm -ivh jdk-8u65-linux-x64.rpm

echo -e '\nJAVA_HOME=/usr/java/jdk1.8.0_65' >> /etc/profile
echo -e '\nJRE_HOME=$JAVA_HOME/jre' >> /etc/profile
echo -e '\nPATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin' >> /etc/profile
echo -e '\nCLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib' >> /etc/profile
echo -e '\nexport JAVA_HOME JRE_HOME PATH CLASSPATH' >> /etc/profile

source /etc/profile

echo -e '\n192.168.10.2 hmaster' >> /etc/hosts
echo -e '\n192.168.10.3 hslave1' >> /etc/hosts
echo -e '\n192.168.10.4 hslave2' >> /etc/hosts

userdel -r hadoop
useradd hadoop
echo -e "vagrant\nvagrant" | (passwd --stdin hadoop)

su hadoop

#每台机器上执行
ssh-keygen -t rsa
ssh-copy-id -i ~/.ssh/id_rsa.pub hadoop@hmaster
ssh-copy-id -i ~/.ssh/id_rsa.pub hadoop@hslave1
ssh-copy-id -i ~/.ssh/id_rsa.pub hadoop@hslave2
chmod 0600 ~/.ssh/authorized_keys

#在hmaster上执行
cd /opt
wget http://mirror.bit.edu.cn/apache/hadoop/common/hadoop-2.6.2/hadoop-2.6.2.tar.gz
tar -zxf hadoop-2.6.2.tar.gz
rm -y hadoop-2.6.2.tar.gz
mv hadoop-2.6.2 hadoop

scp -r hadoop hslave1:/opt
scp -r hadoop hslave2:/opt

#每台机器上执行
echo -e '\nexport HADOOP_PREFIX=/opt/hadoop' >> /home/hadoop/.bashrc
echo -e '\nexport HADOOP_HOME=$HADOOP_PREFIX' >> /home/hadoop/.bashrc
echo -e '\nexport HADOOP_COMMON_HOME=$HADOOP_PREFIX' >> /home/hadoop/.bashrc
echo -e '\nexport HADOOP_CONF_DIR=$HADOOP_PREFIX/etc/hadoop' >> /home/hadoop/.bashrc
echo -e '\nexport HADOOP_HDFS_HOME=$HADOOP_PREFIX' >> /home/hadoop/.bashrc
echo -e '\nexport HADOOP_MAPRED_HOME=$HADOOP_PREFIX' >> /home/hadoop/.bashrc
echo -e '\nexport HADOOP_YARN_HOME=$HADOOP_PREFIX' >> /home/hadoop/.bashrc
echo -e '\nexport PATH=$PATH:$HADOOP_PREFIX/sbin:$HADOOP_PREFIX/bin' >> /home/hadoop/.bashrc




