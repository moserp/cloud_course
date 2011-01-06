package :mtu do
  runner 'ifconfig eth0 mtu 1440'
end

package :app_server do
  requires :apache
  requires :php
end

package :load_balancer do
  requires :apache
end

package :apache do
  apt 'apache2'
end

package :php do
  apt 'libapache2-mod-php5'
end

package :app do
  requires :app_server
  transfer 'index.php', '/var/www/index.php' do
    post :install, 'rm /var/www/index.html && apache2ctl restart'
  end
end

package :apt_sources do
  push_text 'deb http://gb.archive.ubuntu.com/ubuntu/ lucid universe', '/etc/apt/sources.list'
  push_text 'deb-src http://gb.archive.ubuntu.com/ubuntu/ lucid universe', '/etc/apt/sources.list'
  push_text 'deb http://gb.archive.ubuntu.com/ubuntu/ lucid-updates universe', '/etc/apt/sources.list'
  push_text 'deb-src http://gb.archive.ubuntu.com/ubuntu/ lucid-updates universe', '/etc/apt/sources.list'
  noop do
    post :install, 'apt-get update'
  end
end
