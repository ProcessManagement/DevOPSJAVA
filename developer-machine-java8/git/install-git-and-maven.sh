#!/bin/bash

apt-get install git maven

git config --list

read -e -p "Enter your git user.name: " user_name
read -e -p "Enter your git user.email: " user_email

git config --global user.name "$user_name"
git config --global user.email $user_email
git config --global core.editor vim
git config --global push.default matching

git config --list
