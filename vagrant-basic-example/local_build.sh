#!/bin/sh
# Add a local folder structure

DEATHSTAR_HOME="/opt/memorelab/deathstar"

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