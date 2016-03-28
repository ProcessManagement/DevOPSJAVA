#!/bin/bash

echo "================= START STEP-4-INSTALL-LUCEE.SH $(date +"%r") ================="
echo " "
echo "BEGIN setting up Lucee"

# install lucee
if [ ! -d "/opt/lucee" ]; then

	
	# Don't download if we've already got it locally
	if [ -f "/vagrant/artifacts/lucee-4.5.1.000-pl0-linux-x64-installer.run" ]; then
		echo "... Copying Lucee installer ..."
		sudo cp /vagrant/artifacts/lucee-4.5.1.000-pl0-linux-x64-installer.run /root
	else
		echo "... Downloading the Lucee installer, standby ..."
		wget -O /root/lucee-4.5.1.000-pl0-linux-x64-installer.run http://railo.viviotech.net/downloader.cfm/id/133/file/lucee-4.5.1.000-pl0-linux-x64-installer.run &> /dev/null
		sudo cp /root/lucee-4.5.1.000-pl0-linux-x64-installer.run /vagrant/artifacts

	fi
	
	
	
	echo "... Installing Lucee ..."
	chmod +x /root/lucee-4.5.1.000-pl0-linux-x64-installer.run
	cp /vagrant/configs/lucee-options.txt /root
	/root/lucee-4.5.1.000-pl0-linux-x64-installer.run --mode unattended --optionfile /root/lucee-options.txt
fi



echo "... Copying the Lucee config files into place ..."
sudo cp /vagrant/configs/setenv.sh /opt/lucee/tomcat/bin
#sudo cp /vagrant/configs/lucee-server.xml /opt/lucee/lib/lucee-server/context
#sudo cp /vagrant/configs/server.xml /opt/lucee/tomcat/conf/server.xml


echo "... Restarting Lucee ..."
service lucee_ctl restart > /dev/null

echo "... END setting up Lucee."
echo " "
echo "================= FINISH STEP-4-INSTALL-LUCEE.SH $(date +"%r") ================="
echo " "
