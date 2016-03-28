#
# Shell script to install Sun Java, MySQL Server, Ruby, Make, Curl, Git, ZLib, RVM
# on Ubuntu 12.04 LTS OS
#
# Script below installs Sun Java JDK 7 from the Repo

sudo apt-get install python-software-properties
sudo apt-get update

echo "Adding Sun Java repository to the apt repository list..."
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
echo "Done."
echo ""

# Script below installs Curl package
echo "Installing CURL package if not already installed on your system..."
sudo apt-get install curl -y
echo "CURL Installation done."
echo ""
