# encoding: UTF-8

require 'rosette/core'

require 'rosette/data_stores/active_record_data_store'
require 'rosette/extractors/yaml-extractor'
require 'rosette/preprocessors/normalization-preprocessor'
require 'rosette/queuing/resque-queue'
require 'rosette/serializers/yaml-serializer'
require 'rosette/test-helpers'
require 'yaml'

module RosetteConfig
  def self.config
    @config ||= Rosette.build_config do |config|
      config.use_datastore('active-record', database_config_for_env)
      config.use_queue('resque')

      config.add_repo('rosette-demo-rails-app') do |repo|
        repo.set_path(File.join(workspace, 'rosette-demo-rails-app/.git'))
        repo.set_description('A test Rails app for demonstration purposes.')
        repo.add_locales(%w(es de-DE))

        repo.use_tms('test')

        repo.add_extractor('yaml/rails') do |extractor|
          extractor.set_conditions do |cond|
            cond.match_path('config/locales/en.yml')
          end
        end

        repo.add_serializer('rails', format: 'yaml/rails') do |serializer_config|
          serializer_config.add_preprocessor('normalization') do |pre_config|
            pre_config.set_normalization_form(:nfc)
          end
        end
      end
    end
  end

  def self.workspace
    @workspace ||= File.expand_path('../../workspace', __FILE__)
  end

  def self.database_config_for_env
    database_config[Rosette.env]
  end

  def self.database_config
    @database_config ||= YAML.load_file(
      File.expand_path('../database.yml', __FILE__)
    )
  end
end
