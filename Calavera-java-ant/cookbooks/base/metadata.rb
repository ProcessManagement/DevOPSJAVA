name             'base'
maintainer       'Charles Betz'
maintainer_email 'char@erp4it.com'
license          'MIT'
description      'base cookbook to create a new virtual box image'
long_description 'updates packages, updates VirtualBox addin, installs chef & java, curl & tree. Meant to be re-packaged at that point.'
version          '0.3.0'

depends         'curl'
depends         'java7'   # experimenting w/removing java from base build due to tomcat/artifactory incompatibility
