
directory '/var/www' do
    owner node[:app][:user]
    group node[:app][:group]
    mode '0755'
    action :create
end

base_dir = "/var/www/#{node[:app][:name]}"

directory base_dir do
    owner node[:app][:user]
    group node[:app][:group]
    mode '0755'
    action :create
end

directory "#{base_dir}/logs" do
    owner node[:app][:user]
    group node[:app][:group]
    mode '0755'
    action :create
end

git "#{base_dir}/public" do
    repository node[:app][:repository]
    revision node[:app][:revision]
    checkout_branch node[:app][:checkout_branch]
    user node[:app][:user]
    group node[:app][:group]
    action :sync
end

template "#{node[:nginx][:dir]}/sites-available/#{node[:app][:name]}.conf" do
    source 'nginx.conf.erb'
    mode '0644'
end

nginx_site "#{node[:app][:name]}.conf"

directory '/var/ssl' do
    owner 'root'
    group 'root'
    mode '0700'
    action :create
end

file "/var/ssl/#{node[:app][:domain]}.crt" do
    owner 'root'
    group 'root'
    mode '0600'
    action :create
    content data_bag_item('ssl', node[:app][:domain])['crt']
end

file "/var/ssl/#{node[:app][:domain]}.key" do
    owner 'root'
    group 'root'
    mode '0600'
    action :create
    content data_bag_item('ssl', node[:app][:domain])['key']
end
