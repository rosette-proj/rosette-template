# encoding: UTF-8

require 'boot'
require 'config'
require 'rosette/queuing'

namespace :queue do
  task :test, :commit_id do |t, args|
    repo_config = RosetteConfig.config.get_repo('rosette-demo-rails-app')

    latest_commit_id = args[:commit_id] ||
      repo_config.repo.get_rev_commit('HEAD').getId.name

    conductor = Rosette::Queuing::Commits::CommitConductor.new(
      RosetteConfig.config, repo_config.name, Logger.new(STDOUT)
    )

    conductor.enqueue(latest_commit_id)
    puts "Commit #{latest_commit_id} enqueued successfully."
  end
end
