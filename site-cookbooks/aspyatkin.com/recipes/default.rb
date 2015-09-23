
directory '/var/www' do
    owner node[:app][:user]
    group node[:app][:group]
    mode '0755'
    action :create
end

base_dir = "/var/www/#{node[:app][:domain]}"

directory base_dir do
    owner node[:app][:user]
    group node[:app][:group]
    mode '0755'
    action :create
end

# directory "#{base_dir}/logs" do
#     owner node[:app][:user]
#     group node[:app][:group]
#     mode '0755'
#     action :create
# end

git base_dir do
    repository node[:app][:repository]
    revision node[:app][:revision]
    enable_checkout false
    user node[:app][:user]
    group node[:app][:group]
    action :sync
end

template "#{node[:nginx][:dir]}/sites-available/#{node[:app][:domain]}.conf" do
    source 'nginx.conf.erb'
    mode '0644'
    notifies :reload, 'service[nginx]', :delayed
end

template "#{node[:nginx][:dir]}/conf.d/ssl.conf" do
    source 'ssl.conf.erb'
    mode '0644'
    notifies :reload, 'service[nginx]', :delayed
end

nginx_site "#{node[:app][:domain]}.conf"

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

if node[:nginx].has_key? 'ssl_stapling' and node[:nginx][:ssl_stapling]
    file "/var/ssl/#{node[:app][:domain]}-trusted.crt" do
        owner 'root'
        group 'root'
        mode '0600'
        action :create
        content data_bag_item('ssl', node[:app][:domain])['trusted_certs']
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
