apache_module "vhost_alias" do
end

# Copy SSL cert
%w(
  server.key
  server.crt
).each do |file|
  cookbook_file "#{node['apache']['dir']}/ssl/#{file}" do
    source file
    owner "vagrant"
    group "vagrant"
    mode '0600'
  end
end

# Copy vhost configs
%w(
  sites
  sites-ssl
).each do |conf|
  web_app conf do
    template "#{conf}.conf.erb"
    docroot node['misc']['docroot']
    notifies :restart, resources(:service => 'apache2')
  end
end
