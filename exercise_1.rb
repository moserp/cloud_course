require 'common'

# A policy defines a set of package to apply to different roles (machines)
# You can define multiple poilicies.
policy :application, :roles => [:my_server] do
  requires :mtu
  requires :yum_sources

  requires :app
end

# Configure the deployment mechanism (capistrano or vlad)
deployment do
  delivery :capistrano do
    set :user, 'root'
    role :my_server, '109.144.14.239', :primary => true
    default_run_options[:pty] = true
  end
end
