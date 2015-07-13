# encoding: UTF-8

$:.push(File.expand_path('../lib', __FILE__))

require 'boot'
require 'config'

require 'puma'
require 'resque'
require 'resque-scheduler'
require 'resque/scheduler/server'
require 'rosette/queuing/resque-queue'
require 'rosette/server'
require 'rosette/server/github'

resque_server = Rack::Builder.new do
  map '/' do
    use(Rack::Auth::Basic, 'Protected Area') do |username, password|
      allowed_username = ENV['RESQUE_WEB_USERNAME']
      allowed_password = ENV['RESQUE_WEB_PASSWORD']
      username == allowed_username && password == allowed_password
    end

    run Resque::Server
  end
end

api_server = Rosette::Server::ApiV1.new(RosetteConfig.config)
github_server = Rosette::Server::Github.new(rosette_config, {
  github_webhook_secret: ENV['GITHUB_WEBHOOK_SECRET']
})

builder = Rosette::Server::Builder.new
builder.mount('/', api_server)
builder.mount('/github', github_server)
builder.mount('/resque', resque_server)

run builder.to_app
