name 'aspyatkin-nginx'
description 'Installs and configures nginx'
version '1.0.0'

recipe 'aspyatkin-nginx', 'Installs nginx package and sets up configuration with Debian apache style with sites-enabled/sites-available'
depends 'nginx', '2.7.6'
