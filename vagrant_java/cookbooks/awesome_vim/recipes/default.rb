git "/home/vagrant/.vim_runtime" do
  repository "https://github.com/amix/vimrc.git"
  reference "master"
	user "vagrant"
	group "vagrant"
  action :sync
end

execute "install_dot_vimrc" do
  cwd node[:home_folder]
  user "vagrant"
  group "vagrant"
  command "sh /home/vagrant/.vim_runtime/install_basic_vimrc.sh"
end
