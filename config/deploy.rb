set :application, "valobox_api_demo"
set :repository,  "git@github.com:completelynovel/valobox_api_demo.git"

set :scm, :git

set :use_sudo, false
set :user,      "deploy"
set :branch,    "master"
set :deploy_to, "/home/#{user}/web/valobox_api_demo"

set :bundle_without, [:test, :development]

server "dex.valobox.com", :web, :app, :db, primary:  true

##############
# capistrano setup
##############
require 'bundler/capistrano'
set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"
set :bundle_without, [:test, :development]

##############
# rbEnv
##############
def rbenv_string
  "env PATH=$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
end
set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

after "deploy:update_code", "deploy:assets:precompile"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      run "cd #{release_path} && PADRINO_ENV=production bundle exec rake assets:precompile"
    end
  end
end


# load 'deploy/assets' # need to put after deploy:copy_config