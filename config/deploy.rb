set :application, "Cauei labs"
set :repository,  "git://github.com/brunofrank/enki.git"

set :scm, :git

server "deploy@cauei.com.br:35994", :app, :web, :db, :primary => true
set :deploy_to, "/home/deploy/www/labs/"
set :use_sudo, false

namespace :deploy do

  desc "Restart the server"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc "Create a link between database.yaml and database.yml.sample"
  task :link_database_file do
    run "ln -nfs #{release_path}/config/database.example.yml #{release_path}/config/database.yml"
  end   
  
  desc "Run database migrations"  
  task :migrations do
    run "cd #{release_path}; RAILS_ENV=production rake db:migrate"
  end    
  
  desc "Run bundle"  
  task :migrations do
    run "cd #{release_path}; RAILS_ENV=production bundle install"
  end  
end

after 'deploy:update_code', 'deploy:link_database_file'
after 'deploy:update_code', 'deploy:migrations'
after "deploy:migrations", "deploy:cleanup"