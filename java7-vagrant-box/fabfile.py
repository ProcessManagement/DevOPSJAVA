from fabric.api import *
from fabtools.vagrant import vagrant
from fabtools import require, deb

@task
def provision():
    require.file('.vimrc', source='vimrc')
    require.deb.packages([
        'build-essential',
        'openjdk-7-jdk',
        'maven',
        'ant',
        'rake',
        'git',
        'vim'
        ], update=True)
    deb.upgrade()

@task
def provision_glassfish():
    require.file('glassfish.zip', url='http://download.java.net/glassfish/3.1.2.2/release/glassfish-3.1.2.2.zip')
    run('unzip -o glassfish.zip')
    run('echo "AS_ADMIN_PASSWORD=" > /tmp/password.txt')
    run('echo "AS_ADMIN_NEWPASSWORD=adminadmin" >> /tmp/password.txt')
    run('glassfish3/bin/asadmin --user admin --passwordfile /tmp/password.txt change-admin-password --domain_name domain1')
    run('echo "AS_ADMIN_PASSWORD=adminadmin" > /tmp/password.txt')
    run('glassfish3/bin/asadmin start-domain && glassfish3/bin/asadmin --passwordfile /tmp/password.txt --host localhost --port 4848 enable-secure-admin && glassfish3/bin/asadmin stop-domain')
    run('rm /tmp/password.txt')
