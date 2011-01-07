require 'common'

policy :ubuntu, :roles => :app do
  requires :mtu
  requires :apt_sources

  requires :app
end

deployment do
  delivery :capistrano do
    set :user, 'root'
    role :app, '109.144.14.42', :primary => true
    default_run_options[:pty] = true
  end
end
