require 'common'


policy :application, :roles => [:app_1, :app_2] do
  requires :mtu
  requires :yum_sources

  requires :app
end

policy :load_balancer, :roles => [:load_balancer] do
  requires :mtu
  requires :yum_sources

  requires :load_balancer
  requires :load_balancer_config
end

package :load_balancer do
  requires :apache
end

package :load_balancer_config do
  config = <<EOF
<VirtualHost *:80>

  <Proxy balancer://mycluster>
    Order allow,deny
    Allow from all
    BalancerMember http://109.144.14.24:80
    BalancerMember http://109.144.14.25:80
  </Proxy>
  ProxyPass / balancer://mycluster

  ErrorLog /var/log/httpd/error.log
  LogLevel warn

  CustomLog /var/log/httpd/access.log combined
</VirtualHost>
EOF
  push_text config, '/etc/httpd/conf.d/balancer.conf' do
    post :install, 'apachectl restart'
  end
end

deployment do
  delivery :capistrano do
    set :user, 'root'
    role :app_1, '109.144.14.24', :primary => true
    role :app_2, '109.144.14.25'
    role :load_balancer, '109.144.14.243'
    default_run_options[:pty] = true
  end
end
