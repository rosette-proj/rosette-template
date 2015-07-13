source 'https://rubygems.org'

ruby '2.0.0', engine: 'jruby', engine_version: JRUBY_VERSION

gem 'activerecord-jdbcmysql-adapter', '~> 1.3.0'
gem 'puma', '~> 2.11'

# LOCK THIS OR EVERYTHING BREAKS (no idea why)
gem 'jdbc-mysql', '= 5.1.33'

gem 'rosette-active-record',              github: 'rosette-proj/rosette-active-record'
gem 'rosette-core',                       github: 'rosette-proj/rosette-core'
gem 'rosette-extractor-yaml',             github: 'rosette-proj/rosette-extractor-yaml'
gem 'rosette-preprocessor-normalization', github: 'rosette-proj/rosette-preprocessor-normalization'
gem 'rosette-queue-resque',               github: 'rosette-proj/rosette-queue-resque'
gem 'rosette-serializer-yaml',            github: 'rosette-proj/rosette-serializer-yaml'
gem 'rosette-server',                     github: 'rosette-proj/rosette-server'
gem 'rosette-server-github',              github: 'rosette-proj/rosette-server-github'
gem 'rosette-test-helpers',               github: 'rosette-proj/rosette-test-helpers'

group :development, :test do
  gem 'expert', '~> 1.0'
  gem 'pry', '~> 0.9.0'
  gem 'pry-nav'
  gem 'rake'
end
