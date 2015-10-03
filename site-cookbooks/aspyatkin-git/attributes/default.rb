override['git']['version'] = '2.6.0'
override['git']['checksum'] = '3ffdd9072dc16d81f36988f6fa00c7cf3b7ad50decbbf8a3e75df54b8bc967a6'

node.from_file(run_context.resolve_attribute('git', 'default'))
