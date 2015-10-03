default['local-nginx']['ssl_stapling'] = nil
default['local-nginx']['ssl_dhparam'] = nil

override['nginx']['version'] = '1.9.5'
override['nginx']['install_method'] = 'source'
override['nginx']['default_site_enabled'] = false
override['nginx']['source']['modules'] = [
  'nginx::http_gzip_static_module',
  'nginx::http_ssl_module',
  'nginx::ipv6',
  'local-nginx::http_v2_module'
]
override['nginx']['source']['checksum'] = '48e2787a6b245277e37cb7c5a31b1549a0bbacf288aa4731baacf9eaacdb481b'
override['nginx']['server_tokens'] = 'off'

node.from_file(run_context.resolve_attribute('nginx', 'source'))
