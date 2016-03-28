#
# These groups are read by MariaDB server.
# Use it for options that only the server (but not clients) should see
#
# See the examples of server my.cnf files in /usr/share/mysql/
#

# this is read by the standalone daemon and embedded servers
[server]

# this is only for the mysqld standalone daemon
[mysqld]
character-set-server=utf8
#
# * Galera-related settings
#
[galera]
# Mandatory settings
wsrep_provider=/usr/lib64/galera/libgalera_smm.so
# specify all nodes in cluster
wsrep_cluster_address="gcomm://${ownHostInfo.ip},<#list otherHostInfos as hostInfo>${hostInfo.ip}<#if hostInfo_has_next>,</#if></#list>"
binlog_format=row
default_storage_engine=InnoDB
innodb_autoinc_lock_mode=2
innodb_locks_unsafe_for_binlog=1
#bind-address=0.0.0.0
# cluster name
log-error = error.log
wsrep_cluster_name="MariaDB_Cluster"
# own IP address
wsrep_on=ON
wsrep_node_address="${ownHostInfo.ip}"
# replication provider

wsrep_sst_method=rsync
#
# Optional setting
#wsrep_slave_threads=1
#innodb_flush_log_at_trx_commit=0

# this is only for embedded server
[embedded]

# This group is only read by MariaDB servers, not by MySQL.
# If you use the same .cnf file for MySQL and MariaDB,
# you can put MariaDB-only options here
[mariadb]

# This group is only read by MariaDB-10.0 servers.
# If you use the same .cnf file for MariaDB of different versions,
# use this group for options that older servers don't understand
[mariadb-10.0]

