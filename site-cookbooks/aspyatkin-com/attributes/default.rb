id = 'aspyatkin-com'

default[id][:user] = 'vagrant'
default[id][:group] = 'vagrant'
default[id][:fqdn] = 'aspyatkin.dev'

default[id][:repository] = 'https://github.com/aspyatkin/aspyatkin.com'
default[id][:revision] = 'master'

default[id][:hsts_max_age] = 15768000

default[:rbenv][:group_users] = [
  'vagrant'
]
