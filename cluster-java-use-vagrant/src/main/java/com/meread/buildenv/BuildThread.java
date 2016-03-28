package com.meread.buildenv;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import freemarker.template.Configuration;
import freemarker.template.ObjectWrapper;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import net.sf.expectit.Expect;
import net.sf.expectit.ExpectBuilder;
import net.sf.expectit.MultiResult;
import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.TimeUnit;

import static net.sf.expectit.filter.Filters.removeColors;
import static net.sf.expectit.filter.Filters.removeNonPrintable;
import static net.sf.expectit.matcher.Matchers.anyOf;
import static net.sf.expectit.matcher.Matchers.contains;

/**
 * Created by yangxg on 16/1/14.
 */
public class BuildThread {

    private Logger logger = LoggerFactory.getLogger(BuildThread.class);

    private static final int bufferSize = 1024;
    private Session session;
    private Expect expect;
    private Channel channel;

    private HostInfo hostInfo;

    Set<HostInfo> otherHostInfo;

    private static final String ROOT_USER = "root";

    private static final String HADOOP_USER = "hdp";

    public BuildThread(HostInfo hostInfo) {
        this.hostInfo = hostInfo;
        init();
    }

    private Set<HostInfo> getOtherHostInfo() {
        Set<HostInfo> result = new HashSet<>();
        result.addAll(BuildEnv.ALL_HOST);
        result.remove(hostInfo);
        return result;
    }

    public void configJava() throws IOException {
        System.out.println("~~~~~~~~~~~~~安装jdk/scala/maven  start~~~~~~~~~~~~~~");
//        expect.sendLine("java -version");
//            expect.sendLine("wget --no-check-certificate --no-cookies --header \"Cookie: oraclelicense=accept-securebackup-cookie\" http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.rpm");
//            ready(ROOT_USER);
//            expect.sendLine("rpm -ivh jdk-7u79-linux-x64.rpm");
//            ready(ROOT_USER);
        expect.sendLine("tar xvzf /vagrant/download/scala-2.11.7.tgz");
        ready(ROOT_USER);
        expect.sendLine("mv scala-2.11.7 /usr/local/scala");
        ready(ROOT_USER);

        expect.sendLine("tar xvzf /vagrant/download/apache-maven-3.3.9-bin.tar.gz");
        ready(ROOT_USER);
        expect.sendLine("mv apache-maven-3.3.9 /usr/local/maven");
        ready(ROOT_USER);

        expect.sendLine("echo -e 'SCALA_HOME=/usr/local/scala' >> /etc/profile");
        ready(ROOT_USER);
        expect.sendLine("echo -e 'MAVEN_HOME=/usr/local/maven' >> /etc/profile");
        ready(ROOT_USER);
        expect.sendLine("echo -e 'JAVA_HOME=/usr/java/jdk1.7.0_79' >> /etc/profile");
        ready(ROOT_USER);
        expect.sendLine("echo -e 'JRE_HOME=$JAVA_HOME/jre' >> /etc/profile");
        ready(ROOT_USER);
        expect.sendLine("echo -e 'PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin:$SCALA_HOME/bin:$MAVEN_HOME/bin' >> /etc/profile");
        ready(ROOT_USER);
        expect.sendLine("echo -e 'CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib' >> /etc/profile");
        ready(ROOT_USER);
        expect.sendLine("echo -e 'export SCALA_HOME JAVA_HOME JRE_HOME PATH CLASSPATH' >> /etc/profile");
        ready(ROOT_USER);
        expect.sendLine("source /etc/profile");
        ready(ROOT_USER);
        System.out.println("~~~~~~~~~~~~~安装jdk  end~~~~~~~~~~~~~~");
    }

    private void init() {
        otherHostInfo = getOtherHostInfo();
        JSch jSch = new JSch();
        java.util.Properties config = new java.util.Properties();
        config.put("StrictHostKeyChecking", "no");
        try {
            session = jSch.getSession(hostInfo.getUser(), hostInfo.getIp(), hostInfo.getPort());
            session.setConfig(config);
            session.setPassword(hostInfo.getPassword());
            session.connect(5000);
            System.out.println(hostInfo.getIp() + "已连接...");
            channel = session.openChannel("shell");
            channel.connect();
            expect = new ExpectBuilder()
                    .withOutput(channel.getOutputStream())
                    .withInputs(channel.getInputStream(), channel.getExtInputStream())
                    .withEchoInput(System.out)
                    .withEchoOutput(System.err)
                    .withInputFilters(removeColors(), removeNonPrintable())
                    .withExceptionOnFailure()
                    .withTimeout(80000, TimeUnit.SECONDS)
                    .withAutoFlushEcho(true)
                    .withCombineInputs(true)
                    .build();
            System.out.println(expect.getClass().getName());
        } catch (JSchException | IOException e) {
            e.printStackTrace();
            destroy();
            throw new RuntimeException("无法连接" + hostInfo.getIp() + ":" + hostInfo.getPort());
        }
    }

    public void destroy() {
        if (channel != null) {
            channel.disconnect();
        }
        if (expect != null) {
            try {
                expect.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        if (session != null) {
            session.disconnect();
        }
    }

    public void configHostName() throws IOException {
        expect.sendLine("echo '' > /etc/hosts");
        ready(ROOT_USER);
        for (HostInfo info : BuildEnv.ALL_HOST) {
            expect.sendLine("echo '" + info.getIp() + " " + info.getHostName() + "' >> /etc/hosts");
            ready(ROOT_USER);
        }
    }

    public void installLocalRpm() throws IOException {
        expect.sendLine("yum -y remove mariadb-libs");
        expect.expect(contains("Complete!"));
        expect.sendLine("yum -y localinstall /vagrant/download/*.rpm");
        expect.expect(contains("Complete!"));
    }

    public void configSSH(String user) throws IOException {
        System.out.println("~~~~~~~~~~~~~configSSH  start~~~~~~~~~~~~~~");
        this.expect.sendLine("ssh-keygen -t rsa -P \"\" -f ~/.ssh/id_rsa");
        ready(user);
        this.expect.sendLine("cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys");
        ready(user);
        this.expect.sendLine("\\cp -f /vagrant/src/main/resources/ssh/config ~/.ssh");
        ready(user);
        for (HostInfo hi : otherHostInfo) {
            String copyId = "ssh-copy-id -i ~/.ssh/id_rsa.pub " + user + "@" + hi.getHostName();
            this.expect.sendLine(copyId);
            ready(user);
        }
        this.expect.sendLine("chmod 700 -R ~/.ssh");
        ready(user);
        System.out.println("~~~~~~~~~~~~~configSSH  成功~~~~~~~~~~~~~~");
    }

    private void ready(String user) throws IOException {
        expect.expect(contains(user + "@" + hostInfo.getHostName()));
        System.out.flush();
    }

    public void installRequired() throws IOException {
        expect.sendLine("yum -y update");
        ready(ROOT_USER);
        expect.sendLine("yum -y install git nano vim lsof gcc prelink expect openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel gcc-c++ automake autoconf");
        ready(ROOT_USER);
        expect.sendLine("yum -y install perl-Compress-Raw-Bzip2 perl-Compress-Raw-Zlib perl-DBI perl-IO-Compress perl-Net-Daemon perl-PlRPC nmap nmap-ncat");
        ready(ROOT_USER);
        expect.sendLine("yum -y install epel-release net-tools");
        ready(ROOT_USER);
        expect.sendLine("yum --enablerepo=epel -y install sshpass");
        ready(ROOT_USER);
        expect.sendLine("systemctl stop firewalld.service");
        ready(ROOT_USER);
        expect.sendLine("systemctl disable firewalld.service");
        ready(ROOT_USER);
        expect.sendLine("setenforce 0");
        ready(ROOT_USER);
        expect.sendLine("sed -i -e 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux");
        ready(ROOT_USER);
        this.expect.sendLine("\\cp -f /vagrant/src/main/resources/ssh/ssh-copy-id.modified /usr/bin/ssh-copy-id");
        ready(ROOT_USER);
    }

    public void clearSSH(String user) throws IOException {
        this.expect.sendLine("rm -f ~/.ssh/id_rsa && rm -f ~/.ssh/id_rsa.pub && rm -f ~/.ssh/authorized_keys");
        ready(user);
    }

    private void installMariaDB() throws IOException, TemplateException {
        expect.sendLine("\\cp -f /vagrant/src/main/resources/MariaDB.repo /etc/yum.repos.d/MariaDB.repo");
        ready(ROOT_USER);
        expect.sendLine("yum -y --enablerepo=mariadb install MariaDB-client MariaDB-Galera-server galera");
        MultiResult multiResult = this.expect.expect(anyOf(contains("Complete"), contains("Nothing")));
        if (multiResult.getResults().get(0).isSuccessful()) {
            expect.sendLine("yum -y --enablerepo=mariadb install MariaDB-client MariaDB-Galera-server galera");
            expect.expect(anyOf(contains("Complete"), contains("Nothing")));
        }
        genServerConfFile();
    }

    private void localInstallMariaDB() throws IOException, TemplateException {
        expect.sendLine("yum localinstall /vagrant/download/");
        ready(ROOT_USER);
        expect.sendLine("yum -y --enablerepo=mariadb install MariaDB-client MariaDB-Galera-server galera");
        MultiResult multiResult = this.expect.expect(anyOf(contains("Complete"), contains("Nothing")));
        if (multiResult.getResults().get(0).isSuccessful()) {
            expect.sendLine("yum -y --enablerepo=mariadb install MariaDB-client MariaDB-Galera-server galera");
            expect.expect(anyOf(contains("Complete"), contains("Nothing")));
        }
        genServerConfFile();
    }

    public void copyConfig(boolean isFirst) throws IOException, TemplateException {
        genServerConfFile();
        expect.sendLine("\\cp -f /vagrant/src/main/resources/template/server.cnf." + hostInfo.getHostName() + " /etc/my.cnf.d/server.cnf");
        ready(ROOT_USER);
        if (isFirst) {
            configMariaDBFirst();
        }
    }

    public void genServerConfFile() throws IOException, TemplateException {
        Configuration cfg = new Configuration(Configuration.VERSION_2_3_23);
        cfg.setObjectWrapper(ObjectWrapper.BEANS_WRAPPER);
        cfg.setClassForTemplateLoading(this.getClass(), "/");
        Template template = cfg.getTemplate("template/galera_server.ftl");

        // Build the data-model
        Map<String, Object> data = new HashMap<>();
        data.put("ownHostInfo", hostInfo);
        data.put("otherHostInfos", otherHostInfo);
        // Console output
        String path = getClass().getClassLoader().getResource("").getFile();
        FileWriter out = new FileWriter(path + "/template/server.cnf." + hostInfo.getHostName());
        template.process(data, out);
        out.flush();
        out.close();

    }

    public void configMariaDBFirst() throws IOException {
        expect.sendLine("/etc/rc.d/init.d/mysql bootstrap");
        ready(ROOT_USER);
        mysql_secure_installation();
    }

    private void mysql_secure_installation() throws IOException {
        expect.sendLine("sudo /usr/bin/mysql_secure_installation");
        expect.expect(contains("Enter current password"));
        expect.send("\n");
        MultiResult result = expect.expect(anyOf(contains("password"), contains("Access denied")));
        if (result.getResults().get(1).isSuccessful()) {
            expect.send("vagrant\n");
        }
        expect.send("Y\n");
        expect.expect(contains("New password"));
        expect.send("vagrant\n");
        expect.expect(contains("Re-enter"));
        expect.send("vagrant\n");
        expect.expect(contains("Remove anonymous users"));
        expect.send("Y\n");
        expect.expect(contains("Disallow root login remotely"));
        expect.send("n\n");
        expect.expect(contains("Remove test database and access to it"));
        expect.send("n\n");
        expect.expect(contains("Reload"));
        expect.send("Y\n");
        ready(ROOT_USER);
    }

    public void stopMysql() throws IOException {
        expect.send("systemctl stop mysql");
        ready(ROOT_USER);
    }

    public void configMysqlRootLogin() throws IOException {
        expect.sendLine("mysql -uroot -pvagrant -e \"use mysql;update user set host = '%' where user = 'root';\"");
        ready(ROOT_USER);
        expect.sendLine("mysql -uroot -pvagrant -e 'FLUSH PRIVILEGES;'");
        ready(ROOT_USER);
    }

    public void configHaproxy() throws IOException {
        expect.sendLine("yum -y install haproxy");
        expect.expect(contains("Complete!"));
        expect.sendLine("chkconfig haproxy on");
        ready(ROOT_USER);
        expect.sendLine("\\cp -f /vagrant/src/main/resources/haproxy.cfg /etc/haproxy/haproxy.cfg");
        ready(ROOT_USER);
        expect.sendLine("mysql -uroot -h11.11.11.101 -pvagrant -e \"CREATE USER 'haproxy'@'11.11.11.101';\"");
        ready(ROOT_USER);
        expect.sendLine("mysql -uroot -h11.11.11.101 -pvagrant -e \"CREATE USER 'haproxy'@'11.11.11.102';\"");
        ready(ROOT_USER);
        expect.sendLine("mysql -uroot -h11.11.11.101 -pvagrant -e \"CREATE USER 'haproxy'@'11.11.11.103';\"");
        ready(ROOT_USER);
        expect.sendLine("mysql -uroot -h11.11.11.101 -pvagrant -e \"CREATE USER 'haproxy'@'11.11.11.104';\"");
        ready(ROOT_USER);
        expect.sendLine("mysql -uroot -h11.11.11.101 -pvagrant -e 'FLUSH PRIVILEGES;'");
        ready(ROOT_USER);
        expect.sendLine("service haproxy restart");
        ready(ROOT_USER);
    }

    public void startMysql() throws IOException {
        //        mysql -u root -pvagrant -e "show status like 'wsrep%'"
        expect.sendLine("systemctl start mysql");
        ready(ROOT_USER);
        expect.sendLine("mysql");
        expect.expect(contains("using password"));
    }


    public void installRedis() throws IOException {
        System.out.println("~~~~~~~~~~~~~安装redis  start~~~~~~~~~~~~~~");
        expect.sendLine("rm -rf redis-3.0.6");
        ready(ROOT_USER);
        expect.sendLine("tar -zxvf /vagrant/download/redis-3.0.6.tar.gz -C .");
        ready(ROOT_USER);
        expect.sendLine("cd redis-3.0.6");
        ready(ROOT_USER);
        expect.sendLine("make && make install");
        ready(ROOT_USER);
        expect.sendLine("yum -y install ruby rubygems");
        ready(ROOT_USER);
        expect.sendLine("gem sources --add https://ruby.taobao.org/ --remove https://rubygems.org/");
        ready(ROOT_USER);
        expect.sendLine("gem install redis");
        ready(ROOT_USER);
        //6379
        expect.sendLine("utils/install_server.sh");
        expect.expect(contains("the redis port for this instance"));
        expect.send("\n");
        expect.expect(contains("the redis config file name"));
        expect.send("\n");
        expect.expect(contains("the redis log file name"));
        expect.send("\n");
        expect.expect(contains("the data directory for this instance"));
        expect.send("\n");
        expect.expect(contains("executable path"));
        expect.send("\n");
        expect.expect(contains("ENTER"));
        expect.send("\n");
        ready(ROOT_USER);

        //6380
        expect.sendLine("utils/install_server.sh");
        expect.expect(contains("the redis port for this instance"));
        expect.send("6380\n");
        expect.expect(contains("the redis config file name"));
        expect.send("\n");
        expect.expect(contains("the redis log file name"));
        expect.send("\n");
        expect.expect(contains("the data directory for this instance"));
        expect.send("\n");
        expect.expect(contains("executable path"));
        expect.send("\n");
        expect.expect(contains("ENTER"));
        expect.send("\n");
        ready(ROOT_USER);
        System.out.println("~~~~~~~~~~~~~安装redis  end~~~~~~~~~~~~~~");
    }

    public void configRedisCluster() throws IOException {
        expect.sendLine("\\cp -f /vagrant/src/main/resources/redis/6379.conf /etc/redis/6379.conf");
        ready(ROOT_USER);
        expect.sendLine("\\cp -f /vagrant/src/main/resources/redis/6380.conf /etc/redis/6380.conf");
        ready(ROOT_USER);
        expect.sendLine("service redis_6379 restart && service redis_6380 restart");
        ready(ROOT_USER);
    }

    public void createRedisCluster() throws IOException {
        expect.sendLine("/root/redis-3.0.6/src/redis-trib.rb create --replicas 1 11.11.11.101:6379 11.11.11.101:6380 11.11.11.102:6379 11.11.11.102:6380 11.11.11.103:6379 11.11.11.103:6380");
        expect.expect(contains("above configuration"));
        expect.send("yes\n");
        ready(ROOT_USER);
    }

    public void installMongo() throws IOException {
        expect.sendLine("\\cp -f /vagrant/src/main/resources/mongo/mongodb-org-3.2.repo /etc/yum.repos.d/mongodb-org-3.2.repo");
        ready(ROOT_USER);
        expect.sendLine("yum install -y mongodb-org");
        ready(ROOT_USER);
    }

    public void copyMongodbConfig() throws IOException {
        //配置Shard Server
        expect.sendLine("mkdir -p /data/mongodb/{data/{sh0,sh1},backup/{sh0,sh1},log/{sh0,sh1},conf/{sh0,sh1}}");
        ready(ROOT_USER);
        expect.sendLine("\\cp -f /vagrant/src/main/resources/mongo/mongodb0.conf /data/mongodb/conf/sh0/mongodb.conf");
        ready(ROOT_USER);
        expect.sendLine("\\cp -f /vagrant/src/main/resources/mongo/mongodb1.conf /data/mongodb/conf/sh1/mongodb.conf");
        ready(ROOT_USER);
        //配置Config Server
        expect.sendLine("mkdir -p /data/mongodb/{data/cf0,backup/cf0,log/cf0,conf/cf0}");
        ready(ROOT_USER);
        expect.sendLine("\\cp -f /vagrant/src/main/resources/mongo/config.conf /data/mongodb/conf/cf0/config.conf");
        ready(ROOT_USER);
        expect.sendLine("mkdir -p /data/mongodb/{data/ms0,backup/ms0,log/ms0,conf/ms0}");
        ready(ROOT_USER);
        expect.sendLine("\\cp -f /vagrant/src/main/resources/mongo/mongos.conf /data/mongodb/conf/ms0/mongos.conf");
        ready(ROOT_USER);
    }

    public void startShardServer() throws IOException {
        //启动Shard Server
        expect.sendLine("mongod --config /data/mongodb/conf/sh0/mongodb.conf");
        ready(ROOT_USER);
        expect.sendLine("mongod --config /data/mongodb/conf/sh1/mongodb.conf");
        ready(ROOT_USER);
    }

    public void startConfigServer() throws IOException {
        //启动Config Server
        expect.sendLine("mongod --config /data/mongodb/conf/cf0/config.conf");
        ready(ROOT_USER);
    }

    public void startQueryRouters() throws IOException {
        //启动Query Routers
        expect.sendLine("mongos --config /data/mongodb/conf/ms0/mongos.conf");
        ready(ROOT_USER);
    }

    public void configMongoShard() throws IOException {
        //初始化副本集1
        expect.sendLine("mongo --port 27010");
        expect.expect(contains(">"));
        expect.sendLine("use admin");
        expect.expect(contains(">"));
        InputStream resource0 = getClass().getClassLoader().getResourceAsStream("mongo/sh0.bson");
        String content0 = IOUtils.toString(resource0, StandardCharsets.UTF_8);
        String sh0 = "cfg=" + content0;
        System.out.println(sh0);
        expect.sendLine(sh0);
        expect.expect(contains(">"));
        expect.sendLine("rs.initiate(cfg);");
        expect.expect(anyOf(contains("PRIMARY>"), contains("OTHER>"), contains("SECONDARY>")));
        expect.sendLine("exit");
        ready(ROOT_USER);

        //初始化副本集2
        expect.sendLine("mongo --port 27011");
        expect.expect(contains(">"));
        expect.sendLine("use admin");
        expect.expect(contains(">"));
        InputStream resource1 = getClass().getClassLoader().getResourceAsStream("mongo/sh1.bson");
        String content1 = IOUtils.toString(resource1, StandardCharsets.UTF_8);
        String sh1 = "cfg=" + content1;
        System.out.println(sh1);
        expect.sendLine(sh1);
        expect.expect(contains(">"));
        expect.sendLine("rs.initiate(cfg);");
        expect.expect(anyOf(contains("PRIMARY>"), contains("OTHER>"), contains("SECONDARY>")));
        expect.sendLine("exit");
        ready(ROOT_USER);

        //配置分片
        expect.sendLine("mongo --port 30000");
        expect.expect(contains("mongos>"));
        expect.sendLine("use admin");
        expect.expect(contains("mongos>"));
        expect.sendLine("sh.addShard(\"sh0/11.11.11.101:27010,11.11.11.102:27010,11.11.11.103:27010\");");
        expect.expect(contains("mongos>"));
        expect.sendLine("sh.addShard(\"sh1/11.11.11.101:27011,11.11.11.102:27011,11.11.11.103:27011\");");
        expect.expect(contains("mongos>"));

        expect.sendLine("use mydb;");
        expect.expect(contains("mongos>"));

        expect.sendLine("db.createCollection(\"test\");");
        expect.expect(contains("mongos>"));

        expect.sendLine("sh.enableSharding(\"mydb\");");
        expect.expect(contains("mongos>"));

        expect.sendLine("sh.shardCollection(\"mydb.test\", {\"_id\":1});");
        expect.expect(contains("mongos>"));

        expect.sendLine("exit");
        ready(ROOT_USER);
    }

    public void configMongoAutorun() throws IOException {
        expect.sendLine("\\cp -f /vagrant/src/main/resources/mongo/rc.local /etc/rc.local");
        ready(ROOT_USER);
        expect.sendLine("chmod +x /etc/rc.d/rc.local");
        ready(ROOT_USER);
    }

    public void createHadoopUser() throws IOException {
        expect.sendLine("useradd -d /usr/hdp " + HADOOP_USER + " && chmod -R 755 /usr/hdp");
        ready(ROOT_USER);
        expect.sendLine("passwd " + HADOOP_USER);
        expect.expect(contains("New password"));
        expect.sendLine("vagrant");
        expect.expect(contains("Retype"));
        expect.sendLine("vagrant");
        ready(ROOT_USER);
        expect.sendLine("chmod 755 /usr/hdp/.bash_profile");
        ready(ROOT_USER);
        expect.sendLine("\\cp -f /vagrant/src/main/resources/hadoop/sysctl.conf /etc/sysctl.conf");
        ready(ROOT_USER);
    }

    public void copyHadoopConfig() throws IOException {
        expect.sendLine("su " + HADOOP_USER);
        ready(HADOOP_USER);
        configSSH(HADOOP_USER);
        expect.sendLine("cd ~");
        ready(HADOOP_USER);
        expect.sendLine("mkdir hadoop spark");
        ready(HADOOP_USER);
        expect.sendLine("tar zxf /vagrant/download/hadoop-2.6.3.tar.gz -C ~/hadoop --strip-components 1 ");
        ready(HADOOP_USER);
        expect.sendLine("echo -e ' ' >> ~/.bash_profile");
        ready(HADOOP_USER);
        expect.sendLine("echo -e 'export HADOOP_HOME=/usr/hdp/hadoop' >> ~/.bash_profile");
        ready(HADOOP_USER);
        expect.sendLine("echo -e 'export HADOOP_COMMON_HOME=$HADOOP_HOME' >> ~/.bash_profile");
        ready(HADOOP_USER);
        expect.sendLine("echo -e 'export HADOOP_HDFS_HOME=$HADOOP_HOME' >> ~/.bash_profile");
        ready(HADOOP_USER);
        expect.sendLine("echo -e 'export HADOOP_MAPRED_HOME=$HADOOP_HOME' >> ~/.bash_profile");
        ready(HADOOP_USER);
        expect.sendLine("echo -e 'export HADOOP_YARN_HOME=$HADOOP_HOME' >> ~/.bash_profile");
        ready(HADOOP_USER);
        expect.sendLine("echo -e 'export HADOOP_OPTS=\"-Djava.library.path=$HADOOP_HOME/lib/native\"' >> ~/.bash_profile");
        ready(HADOOP_USER);
        expect.sendLine("echo -e 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native' >> ~/.bash_profile");
        ready(HADOOP_USER);
        expect.sendLine("tar -zxf /vagrant/download/spark-1.5.2-bin-hadoop2.6.tgz -C ~/spark --strip-components 1");
        ready(HADOOP_USER);
        expect.sendLine("echo 'export SPARK_HOME=/usr/hdp/spark' >> ~/.bash_profile");
        ready(HADOOP_USER);

        expect.sendLine("echo -e 'export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$SPARK_HOME/bin' >> ~/.bash_profile");
        ready(HADOOP_USER);
        expect.sendLine("source ~/.bash_profile");
        ready(HADOOP_USER);
    }

    public void configHadoop() throws IOException {
        expect.sendLine("mkdir ~/datanode");
        ready(HADOOP_USER);
        expect.sendLine("ssh node2 \"mkdir ~/datanode\" && ssh node3 \"mkdir ~/datanode\"");
        ready(HADOOP_USER);
        expect.sendLine("\\cp -f /vagrant/src/main/resources/hadoop/hdfs-site.xml ~/hadoop/etc/hadoop/hdfs-site.xml");
        ready(HADOOP_USER);
        expect.sendLine("scp ~/hadoop/etc/hadoop/hdfs-site.xml node2:~/hadoop/etc/hadoop/");
        ready(HADOOP_USER);
        expect.sendLine("scp ~/hadoop/etc/hadoop/hdfs-site.xml node3:~/hadoop/etc/hadoop/");
        ready(HADOOP_USER);

        expect.sendLine("\\cp -f /vagrant/src/main/resources/hadoop/core-site.xml ~/hadoop/etc/hadoop/core-site.xml");
        ready(HADOOP_USER);
        expect.sendLine("scp ~/hadoop/etc/hadoop/core-site.xml node2:~/hadoop/etc/hadoop/");
        ready(HADOOP_USER);
        expect.sendLine("scp ~/hadoop/etc/hadoop/core-site.xml node3:~/hadoop/etc/hadoop/");
        ready(HADOOP_USER);

        expect.sendLine("sed -i -e 's/\\${JAVA_HOME}/\\/usr\\/java\\/default/' ~/hadoop/etc/hadoop/hadoop-env.sh");
        ready(HADOOP_USER);
        expect.sendLine("scp ~/hadoop/etc/hadoop/hadoop-env.sh node2:~/hadoop/etc/hadoop/");
        ready(HADOOP_USER);
        expect.sendLine("scp ~/hadoop/etc/hadoop/hadoop-env.sh node3:~/hadoop/etc/hadoop/");
        ready(HADOOP_USER);

        expect.sendLine("mkdir ~/namenode");
        ready(HADOOP_USER);
        expect.sendLine("\\cp -f /vagrant/src/main/resources/hadoop/hdfs-site-master.xml ~/hadoop/etc/hadoop/hdfs-site.xml");
        ready(HADOOP_USER);
        expect.sendLine("\\cp -f /vagrant/src/main/resources/hadoop/mapred-site.xml ~/hadoop/etc/hadoop/mapred-site.xml");
        ready(HADOOP_USER);
        expect.sendLine("\\cp -f /vagrant/src/main/resources/hadoop/yarn-site.xml ~/hadoop/etc/hadoop/yarn-site.xml");
        ready(HADOOP_USER);
        expect.sendLine("\\cp -f /vagrant/src/main/resources/hadoop/slaves ~/hadoop/etc/hadoop/slaves");
        ready(HADOOP_USER);
    }

    public void startHadoop() throws IOException {
        expect.sendLine("~/hadoop/bin/hdfs namenode -format");
        ready(HADOOP_USER);
        expect.sendLine("~/hadoop/sbin/start-dfs.sh");
        ready(HADOOP_USER);
        expect.sendLine("~/hadoop/sbin/start-yarn.sh");
        ready(HADOOP_USER);
        expect.sendLine("jps");
        ready(HADOOP_USER);

        expect.sendLine("~/hadoop/bin/hdfs dfs -mkdir /test");
        ready(HADOOP_USER);
        expect.sendLine("~/hadoop/bin/hdfs dfs -copyFromLocal ~/hadoop/NOTICE.txt /test");
        ready(HADOOP_USER);
        expect.sendLine("~/hadoop/bin/hdfs dfs -cat /test/NOTICE.txt");
        ready(HADOOP_USER);
        expect.sendLine("~/hadoop/bin/hadoop jar ~/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.3.jar wordcount /test/NOTICE.txt /output01");
        ready(HADOOP_USER);
        expect.sendLine("~/hadoop/bin/hdfs dfs -ls /output01");
        ready(HADOOP_USER);
        expect.sendLine("~/hadoop/bin/hdfs dfs -cat /output01/part-r-00000");
        ready(HADOOP_USER);
    }


    public void configSpark() throws IOException {
        expect.sendLine("\\cp -f /vagrant/src/main/resources/spark/spark-env.sh ~/spark/conf/spark-env.sh");
        ready(HADOOP_USER);
        expect.sendLine("chmod 755 ~/spark/conf/spark-env.sh");
        ready(HADOOP_USER);
        expect.sendLine("\\cp -f /vagrant/src/main/resources/spark/slaves ~/spark/conf/slaves");
        ready(HADOOP_USER);
    }

}
