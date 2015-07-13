# encoding: UTF-8

require 'rosette/data_stores/active_record/tasks'

namespace :db do
  task :connect do
    RosetteConfig.config
  end

  task setup: :connect do
    Rake::Task['rosette:ar:setup'].invoke
  end

  task migrate: :connect do
    Rake::Task['rosette:ar:migrate'].invoke
  end

  task rollback: :connect do
    Rake::Task['rosette:ar:rollback'].invoke
  end
end
