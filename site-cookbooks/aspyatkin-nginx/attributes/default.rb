default['nginx']['version'] = '1.9.5'
default['nginx']['install_method'] = 'source'
default['nginx']['default_site_enabled'] = false
default['nginx']['source']['version'] = '1.9.5'
default['nginx']['source']['modules'] = [
  'nginx::http_gzip_static_module',
  'nginx::http_ssl_module',
  'nginx::ipv6',
  'aspyatkin-nginx::http_v2_module'
]
default['nginx']['source']['checksum'] = '48e2787a6b245277e37cb7c5a31b1549a0bbacf288aa4731baacf9eaacdb481b'
default['nginx']['server_tokens'] = 'off'
default['nginx']['ssl_stapling'] = false
