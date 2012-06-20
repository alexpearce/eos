require "bundler/capistrano"

# Load rbenv
set :default_environment, {
  "PATH" => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

set :applications, "eos"
set :user, "deploy"
set :use_sudo, false

# Required for sudo password prompt
default_run_options[:pty] = true

# Use git, set the repo
set :scm, :git
set :repository,  "git@github.com:alexpearce/eos.git"

set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
 
# server roles
role :app, "31.193.143.153"

# After an initial (cold) deploy, symlink the app and restart nginx
after "deploy:cold" do
  admin.symlink_config
  admin.nginx_restart
end

namespace :deploy do
  desc "Not starting as we're running passenger."
  task :start do
  end

  desc "Not stopping as we're running passenger."
  task :stop do
  end

  desc "Restart the app."
  task :restart, roles: :app, except: { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  # This will make sure that Capistrano doesn't try to run rake:migrate (this is not a Rails project!)
  task :cold do
    deploy.update
    deploy.start
  end
end

namespace :admin do
  desc "Link the server config to nginx."
  task :symlink_config, roles: :app do
    run "#{sudo} ln -nfs #{deploy_to}/current/config/nginx.server /etc/nginx/sites_enabled/#{application}"
  end

  desc "Unlink the server config."
  task :unlink_config, roles: :app do
    run "#{sudo} rm /etc/nginx/sites_enabled/#{application}"
  end

  desc "Restart nginx."
  task :nginx_restart, roles: :app do
    run "#{sudo} /etc/init.d/nginx restart"
  end
end