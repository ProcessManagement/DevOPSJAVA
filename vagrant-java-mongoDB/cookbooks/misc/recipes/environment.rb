bash "Vagrant export" do
  user "root"
  code <<-EOS
  echo "export VAGRANT_BOX=1" >> /etc/environment
  EOS
  not_if "grep -q VAGRANT_BOX /etc/environment"
end

# Set sphinx files up
template "/etc/sphinxsearch/sphinx.conf" do
  source "sphinx.conf.erb"
  owner "vagrant"
  group "vagrant"
  mode "0644"
end

template "/etc/default/sphinxsearch" do
  source "sphinxsearch.erb"
  owner "sphinxsearch"
  group "vagrant"
  mode "0644"
end

# Create sphinx directories
%w(
	/var/sphinxsearch
	/var/log/sphinxsearch
).each do |dirpath|
	directory dirpath do
	  owner "sphinxsearch"
	  group "vagrant"
	  mode 0777
	  action :create
	end
end
