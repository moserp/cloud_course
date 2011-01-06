require 'common'


policy :ubuntu, :roles => [:app_1, :app_2] do
  requires :mtu
  requires :apt_sources

  requires :app
end

policy :load_balancer, :roles => [:load_balancer] do
  requires :mtu
  requires :apt_sources

  requires :load_balancer
  requires :load_balancer_config
end

package :load_balancer_config do
  config = <<EOF
<VirtualHost *:80>

  <Proxy balancer://mycluster>
    Order allow,deny
    Allow from all
    BalancerMember http://109.144.14.183:80
    BalancerMember http://109.144.14.184:80
  </Proxy>
  ProxyPass / balancer://mycluster

  ErrorLog /var/log/apache2/error.log
  LogLevel warn

  CustomLog /var/log/apache2/access.log combined
</VirtualHost>
EOF
  push_text config, '/etc/apache2/sites-available/balancer.conf'
  runner 'ln -s /etc/apache2/sites-available/balancer.conf /etc/apache2/sites-enabled/00-balancer.conf'
  runner 'ln -s /etc/apache2/mods-available/proxy.conf /etc/apache2/mods-enabled/proxy.conf'
  runner 'ln -s /etc/apache2/mods-available/proxy.load /etc/apache2/mods-enabled/proxy.load'
  runner 'ln -s /etc/apache2/mods-available/proxy_http.load /etc/apache2/mods-enabled/proxy_http.load'
  runner 'ln -s /etc/apache2/mods-available/proxy_balancer.load /etc/apache2/mods-enabled/proxy_balancer.load'
  runner 'apache2ctl restart'
end

deployment do
  delivery :capistrano do
    set :user, 'root'
    role :app_1, '109.144.14.183', :primary => true
    role :app_2, '109.144.14.184'
    role :load_balancer, '109.144.14.185'
    default_run_options[:pty] = true
  end
end
