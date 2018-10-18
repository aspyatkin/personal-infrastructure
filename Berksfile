source 'https://api.berkshelf.com'

solver :gecode, :preferred

cookbook 'build-essential'
cookbook 'ntp'
cookbook 'git', '~> 9.0.0'
cookbook 'locale', '~> 2.0.1'
cookbook 'poise-python', '1.7.0'
cookbook 'ufw', '~> 3.1.1'
cookbook 'dhparam', '~> 1.0.0'
cookbook 'nsd', '~> 0.2.0'

cookbook 'dotfiles',
		 git: 'https://github.com/aspyatkin/dotfiles-cookbook',
		 tag: 'v1.4.0'

cookbook 'latest-git',
		 git: 'https://github.com/aspyatkin/latest-git',
		 tag: 'v1.5.0'
