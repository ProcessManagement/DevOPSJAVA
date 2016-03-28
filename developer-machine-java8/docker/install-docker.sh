 #!/bin/bash
 
 # install docker
export NO_PROXY="/var/run/docker.sock"
wget -qO- https://get.docker.com/ | sudo sh
sudo usermod -aG docker ${USER}

echo "Ralfs hint: you can also use"
echo "    newgrp docker "
echo " to use docker without sudo without logout/login"
