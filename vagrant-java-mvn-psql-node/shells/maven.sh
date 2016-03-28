#!/usr/bin/env bash
 

# Install Maven 3

sudo apt-get update -y
sudo apt-get install maven -y

## For debugging purpose: mvn exec:exec -Dexec.executable="java" -Dexec.args="-classpath %classpath -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8001 com.asimplemodule.dbeb.App"
echo "Installed maven 3 **************************************************************"  
