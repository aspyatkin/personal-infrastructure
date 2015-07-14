# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
require 'json'


def get_node_opts
  filename = File.join __dir__, 'nodes', 'vagrant.json'
  if File.exists? filename
    JSON.load File.open filename
  else
    {}
  end
end


def get_vm_opts
  filename = File.join __dir__, 'opts.yml'
  if File.exists? filename
    YAML.load File.open filename
  else
    {}
  end
end


Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/trusty64'

  vm_opts = get_vm_opts

  if vm_opts.has_key? 'network'
    vm_opts['network'].each do |key, value|
      opt = Hash[value.map { |(k,v)| [k.to_sym, v] }]
      config.vm.network key, **opt
    end
  end

  if vm_opts.has_key? 'ram'
    config.vm.provider :virtualbox do |v|
      v.memory = vm_opts['ram']
    end
  end

  if vm_opts.has_key? 'synced_folder'
    vm_opts['synced_folder'].each do |entry|
      opts = Hash[entry['opts'].map { |(k,v)| [k.to_sym, v] }]
      config.vm.synced_folder entry['host'], entry['guest'], **opts
    end
  end

  node_opts = get_node_opts

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ['site-cookbooks', 'cookbooks']
    chef.roles_path = 'roles'
    chef.data_bags_path = 'data_bags'
    chef.provisioning_path = '/tmp/vagrant-chef'
    chef.encrypted_data_bag_secret_key_path = File.join __dir__, 'data_bag_key'

    chef.run_list = node_opts.delete 'run_list'
    chef.json = node_opts
  end
end
