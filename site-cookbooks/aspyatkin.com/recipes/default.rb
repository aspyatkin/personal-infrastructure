include_recipe 'latest-git'
include_recipe 'latest-nodejs'
include_recipe 'local-nginx'
include_recipe 'local-rbenv'
include_recipe 'dotfiles'

base_dir = "/var/www/#{node[:app][:domain]}"

directory base_dir do
    owner node[:app][:user]
    group node[:app][:group]
    mode 0755
    recursive true
    action :create
end

git base_dir do
    repository node[:app][:repository]
    revision node[:app][:revision]
    enable_checkout false
    user node[:app][:user]
    group node[:app][:group]
    action :sync
end

letsencrypt_root = '/var/www/letsencrypt'
letsencrypt_dir = ::File.join letsencrypt_root, '.well-known', 'acme-challenge'

directory letsencrypt_dir do
    owner 'root'
    group node['root_group']
    mode 0755
    recursive true
    action :create
end

node_env = 'development'
if node[:app].has_key? 'environment'
    node_env = node[:app][:environment]
end

data_bag_item('letsencrypt', node_env)['dv'].each do |key, value|
    path = ::File.join letsencrypt_dir, key
    file path do
        owner 'root'
        group node['root_group']
        mode 0644
        content value
        action :create
    end
end

template "#{node[:nginx][:dir]}/sites-available/#{node[:app][:domain]}.conf" do
    source 'nginx.conf.erb'
    mode 0644
    notifies :reload, 'service[nginx]', :delayed
    action :create
end

template "#{node[:nginx][:dir]}/conf.d/ssl.conf" do
    source 'ssl.conf.erb'
    mode 0644
    notifies :reload, 'service[nginx]', :delayed
    action :create
end

nginx_site "#{node[:app][:domain]}.conf"

directory '/var/ssl' do
    owner 'root'
    group node['root_group']
    mode 0700
    action :create
end

file "/var/ssl/#{node[:app][:domain]}.crt" do
    owner 'root'
    group node['root_group']
    mode 0600
    content data_bag_item('ssl', node_env)['crt']
    action :create
end

file "/var/ssl/#{node[:app][:domain]}.key" do
    owner 'root'
    group node['root_group']
    mode 0600
    content data_bag_item('ssl', node_env)['key']
    action :create
end

if node['local-nginx'].has_key? 'ssl_stapling' and node['local-nginx'][:ssl_stapling]
    file "/var/ssl/#{node[:app][:domain]}-trusted.crt" do
        owner 'root'
        group node['root_group']
        mode 0600
        content data_bag_item('ssl', node_env)['trusted_certs']
        action :create
    end
end

ENV['CONFIGURE_OPTS'] = '--disable-install-rdoc'

rbenv_ruby '2.2.2' do
    ruby_version '2.2.2'
    global true
end

rbenv_gem 'bundler' do
    ruby_version '2.2.2'
end

rbenv_execute 'Install bundle' do
    command 'bundle'
    ruby_version '2.2.2'
    cwd base_dir
    user node[:app][:user]
    group node[:app][:group]
end

rbenv_execute 'Build website' do
    command 'jekyll build'
    ruby_version '2.2.2'
    cwd base_dir
    user node[:app][:user]
    group node[:app][:user]
    environment 'JEKYLL_ENV' => node[:app][:environment]
end
