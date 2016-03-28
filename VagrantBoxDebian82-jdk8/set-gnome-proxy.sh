#!/bin/sh


if [ -n "$http_proxy" ]; then

  export PROXY_WITHOUT_CREDS=`echo $http_proxy | sed -e 's/\/\/.*@/\/\//'`
  export PROXY_PROT=`echo $PROXY_WITHOUT_CREDS | sed -e 's/\/\/.*/\/\//g'`
  export PROXY_URL_PORT=`echo $PROXY_WITHOUT_CREDS | sed -e 's/.*\/\///'`
  export PROXY_URL=`echo $PROXY_URL_PORT | sed -e 's/:.*//'`
  export PROXY_PORT=`echo $PROXY_URL_PORT | sed -e 's/.*://'`
  export PROXY_CREDS=`echo $http_proxy | sed -e 's/.*\/\///' |sed -e 's/@.*//'`
  export PROXY_USER=`echo $PROXY_CREDS | sed -e 's/:.*//'`
  export PROXY_PWD=`echo $PROXY_CREDS | sed -e 's/.*://'`

  gsettings set org.gnome.system.proxy.http host $PROXY_URL
  gsettings set org.gnome.system.proxy.https host $PROXY_URL
  gsettings set org.gnome.system.proxy.http port $PROXY_PORT
  gsettings set org.gnome.system.proxy.https port $PROXY_PORT
  gsettings set org.gnome.system.proxy.ftp host $PROXY_URL
  gsettings set org.gnome.system.proxy.ftp port $PROXY_PORT
  gsettings set org.gnome.system.proxy.http use-authentication true
  gsettings set org.gnome.system.proxy.http authentication-password $PROXY_PWD
  gsettings set org.gnome.system.proxy.http authentication-user $PROXY_USER

  unset PROXY_WITHOUT_CREDS
  unset PROXY_PROT
  unset PROXY_URL_PORT
  unset PROXY_URL
  unset PROXY_PORT
  unset PROXY_CREDS
  unset PROXY_USER
  unset PROXY_PWD

fi
