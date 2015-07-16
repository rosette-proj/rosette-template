# encoding: UTF-8

require 'java'
java_import java.lang.System

require 'expert'
Expert.environment.require_all

require 'dotenv'
Dotenv.load

require 'logger'
require 'rosette/core'
Rosette.env = ENV['ROSETTE_ENV'] || System.getProperty('ROSETTE_ENV') || 'development'
Rosette.logger = Logger.new(STDOUT)

require 'active_record'
ActiveRecord::Base.logger = Rosette.logger

# add write method to appease Rack::CommonLogger
class ::Logger
  alias_method :write, :<<
end

# are we running in a servlet?
if JRuby.const_defined?(:Rack)
  use Rack::CommonLogger, Rosette.logger
end

# workaround for https://github.com/jruby/jruby/issues/2035
Encoding.default_external = 'utf-8'
