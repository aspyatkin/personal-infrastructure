include_recipe 'nginx::source'

ssl_defaults_conf = ::File.join node[:nginx][:dir], 'conf.d', 'ssl_defaults.conf'

dhparam_path = ::File.join node[:nginx][:dir], 'dhparam.pem'

execute 'Create OpenSSL dhparam file' do
  command "openssl dhparam 2048 -out #{dhparam_path}"
  user 'root'
  group node['root_group']
  creates dhparam_path
  action :run
end

template ssl_defaults_conf do
  source 'ssl.defaults.erb'
  mode 0644
  notifies :reload, 'service[nginx]', :delayed
  variables ssl_dhparam: dhparam_path
  action :create
end
