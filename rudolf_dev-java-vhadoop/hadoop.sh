
cd
wget http://apache.mirrors.timporter.net/hadoop/common/hadoop-1.0.4/hadoop-1.0.4.tar.gz
tar -xvf hadoop-1.0.4.tar.gz
mv hadoop-1.0.4 hadoop
echo "export JAVA_HOME=/usr/lib/jvm/java-7-oracle" >> $HOME/.bashrc
export JAVA_HOME=/usr/lib/jvm/java-7-oracle
echo "export HADOOP_HOME=/home/vagrant/hadoop" >> $HOME/.bashrc
export HADOOP_HOME=/home/vagrant/hadoop
echo "export PATH=$PATH:$JAVA_HOME:$HADOOP_HOME/bin" >> $HOME/.bashrc
bash
