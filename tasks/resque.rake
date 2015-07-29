# encoding: UTF-8

require 'boot'
require 'config'
require 'rosette/queuing/resque-queue'

namespace :resque do
  QUEUES = ['commits']

  task work: :queue_env do
    worker.start_worker
  end

  task schedule: :queue_env do
    worker.start_scheduler
  end

  task :queue_env do
    ENV['QUEUE'] ||= QUEUES.join(',')
  end

  def worker
    @worker ||= Rosette::Queuing::ResqueQueue::Worker.new(
      RosetteConfig.config, Rosette.logger,
      RosetteConfig.config.queue.configurator.queue_options
    )
  end
end
