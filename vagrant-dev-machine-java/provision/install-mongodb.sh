#!/bin/bash

#en: setting mongo repository to run the yum
#pt: configurando o repositorio mongo para executar o yum
cd /etc/yum.repos.d/
touch mongodb-org-3.0.repo
echo "[mongodb-org-3.0]" >> mongodb-org-3.0.repo
echo "name=MongoDB Repository" >> mongodb-org-3.0.repo
echo "baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/3.0/x86_64/" >> mongodb-org-3.0.repo
echo "gpgcheck=0" >> mongodb-org-3.0.repo
echo "enabled=1" >> mongodb-org-3.0.repo

#en: installation
#pt: instalando
sudo yum install -y mongodb-org