api: bundle exec rackup -p 8080
queue-worker: env QUEUE=commits bundle exec rake resque:work
queue-scheduler: env QUEUE=commits bundle exec rake resque:schedule
