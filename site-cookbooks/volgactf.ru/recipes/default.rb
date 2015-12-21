include_recipe 'latest-git'
include_recipe 'latest-nodejs'
include_recipe 'local-nginx'

id = 'volgactf.ru'

base_dir = "/var/www/#{node[id][:fqdn]}"

directory base_dir do
  owner node[id][:user]
  group node[id][:group]
  mode 0755
  recursive true
  action :create
end

git base_dir do
  repository node[id][:repository]
  revision node[id][:revision]
  enable_checkout false
  user node[id][:user]
  group node[id][:group]
  action :sync
end

nodejs_npm '.' do
  path base_dir
  json true
  user node[id][:user]
  group node[id][:group]
end

execute 'Install Bower packages' do
  command 'npm run bower -- install'
  cwd base_dir
  user node[id][:user]
  group node[id][:group]
  environment 'HOME' => "/home/#{node[id][:user]}"
end

execute 'Build assets' do
  command 'npm run grunt'
  cwd base_dir
  user node[id][:user]
  group node[id][:group]
  environment 'HOME' => "/home/#{node[id][:user]}"
end

template "#{node[:nginx][:dir]}/sites-available/#{node[id][:fqdn]}.conf" do
  source 'nginx.conf.erb'
  mode 0644
  notifies :reload, 'service[nginx]', :delayed
  variables fqdn: node[id][:fqdn]
  action :create
end

nginx_site "#{node[id][:fqdn]}.conf"
