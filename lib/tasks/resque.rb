require 'resque/tasks'
#require 'resque/scheduler/tasks'
task 'resque:setup' => :environment

namespace :resque do
  task :setup do
    require 'resque'
    #require 'resque_scheduler'
    #require 'resque/scheduler'

    ENV['QUEUE'] ||= '*'
    #ENV['QUEUE'] = '*'

    Resque.redis = 'localhost:6379' unless Rails.env == 'production'
    #Resque.schedule = YAML.load_file(File.join(Rails.root, 'config/resque_scheduler.yml'))
  end
end

Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"