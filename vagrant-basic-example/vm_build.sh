	#Vagrant version 1.0.6
	date > /etc/vagrant_provisioned_at
	DEATHSTAR_HOME="/opt/memorelab/deathstar"

	if [ ! -f /home/vagrant/isProvisioned.txt ];
	then
	    echo "First run, I'll setup all system my master!"
		apt-get update -y
		apt-get upgrade -y
		wget https://opscode-omnibus-packages.s3.amazonaws.com/debian/6/x86_64/chef_10.24.4-1.debian.6.0.5_amd64.deb
		dpkg -i chef_10.24.4-1.debian.6.0.5_amd64.deb
		apt-get install -y httrack
		echo "READY!" > /home/vagrant/isProvisioned.txt
		
		echo "Setting deathstar..."
		echo "Creating folders"

		echo "$DEATHSTAR_HOME/PreDOM"
		mkdir -p $DEATHSTAR_HOME/PreDOM

		echo "$DEATHSTAR_HOME/PosDOM"
		mkdir -p $DEATHSTAR_HOME/PosDOM

		echo "$DEATHSTAR_HOME/Resources"
		mkdir -p $DEATHSTAR_HOME/Resources

		echo "$DEATHSTAR_HOME/Application/Redxiii"
		mkdir -p $DEATHSTAR_HOME/Application/Redxiii

		echo "$DEATHSTAR_HOME/Application/Broker"
		mkdir -p $DEATHSTAR_HOME/Application/Broker
		
		# TODO: Fix this permission!
		chmod -R 777 $DEATHSTAR_HOME
		
	fi
		/etc/init.d/apache2 restart
		echo "I believe all are setup for you MASTER! Now running CHEF!"
