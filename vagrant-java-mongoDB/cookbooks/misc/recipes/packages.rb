# add the 10gen Mongo PPA; grab key from keyserver
apt_repository "10gen" do
  uri "http://downloads-distro.mongodb.org/repo/#{node[:misc][:mongo][:apt_repo]}"
  distribution "dist"
  components ["10gen"]
  keyserver "hkp://keyserver.ubuntu.com:80"
  key "7F0CEB10"
  action :add
end

# Add the nodejs PPA
apt_repository "chris-lea-node.js" do
  uri "http://ppa.launchpad.net/chris-lea/node.js/ubuntu"
  distribution node["lsb"]["codename"]
  components ["main"]
  key "C7917B12"
  keyserver "keyserver.ubuntu.com"
  action :add
end

# Install some misc packages
node[:misc][:packages].each do |app|
  package app do
    action :install
  end
end

# phpunit/PHPUnit depends on symfony/YAML
channels = %w{pear.phpunit.de pear.symfony.com}
channels.each do |chan|
  php_pear_channel chan do
    action [:discover, :update]
  end
end

# Install some misc pear/pecl packages
%w(
  mongo
).each do |package|
  php_pear package do
    action :install
  end
end
