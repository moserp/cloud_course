package :mtu do
  runner 'ifconfig eth0 mtu 1440'
end

package :app_server do
  requires :apache
  requires :php
end

package :apache do
  yum 'httpd' do
    post :install, 'apachectl start'
  end
end

package :php do
  yum 'php' do
    post :install, 'apachectl restart'
  end
end

package :app do
  requires :app_server
  transfer 'index.php', '/var/www/html/index.php' do
    post :install, 'apachectl restart'
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

package :yum_sources do
  transfer 'CentOS-Base.repo', '/etc/yum.repos.d/CentOS-Base.repo'
end
