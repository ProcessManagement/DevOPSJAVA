#!/usr/bin/ruby

require 'yaml'
config = YAML.load_file('config.yml-dist')

puts "Setting up the development VM for the first time.\nThis process will take about 10 minutes depending on your machine."

# Setup the configuration YAML
print "What is the path of your project files? "
filePath = gets.strip
config['vagrant']['share_path'] = filePath
f = File.open('config.yml', 'w'); f.write(YAML.dump(config)); f.close

puts "\tSubmodule importing..."

system 'git submodule update --init --recursive'

puts "\tSetting up vagrant..."

system 'vagrant plugin install vagrant-hostsupdater'

puts "\tSetup complete. Run 'vagrant up' to start the vagrant machine."
