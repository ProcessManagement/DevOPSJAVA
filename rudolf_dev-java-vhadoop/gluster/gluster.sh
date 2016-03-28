##
# GlusterFS installation shell script
##

echo "Gluster Installation Script on Fedora 17 Linux system"
echo ""
echo "Downloading Gluster 3.3.1 Repository..."
echo ""
wget http://download.gluster.org/pub/gluster/glusterfs/3.3/3.3.1/Fedora/glusterfs-fedora.repo
echo ""
echo "Gluster 3.3.1 Repository Download completed."
echo ""
echo "Moving Repository to Fedora 17 YUM Repository..."
mv glusterfs-fedora.repo /etc/yum.repos.d/
echo "Done."
echo ""
echo "Installing Gluster 3.3.1 on Fedora 17 system..."
sudo yum --enablerepo=glusterfs-fedora install glusterfs
echo "Done."
echo "Gluster Installation Completed."
echo "Bye!"

# End of Installation Script 
