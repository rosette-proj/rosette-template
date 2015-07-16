# encoding: UTF-8

require 'rosette/core'

require 'rosette/data_stores/active_record_data_store'
require 'rosette/extractors/yaml-extractor'
require 'rosette/preprocessors/normalization-preprocessor'
require 'rosette/queuing/resque-queue'
require 'rosette/serializers/yaml-serializer'
require 'rosette/tms/filestore-tms'
require 'rosette/test-helpers'
require 'yaml'

module RosetteConfig
  def self.config
    @config ||= Rosette.build_config do |config|
      # Use active record via the jdbc mysql2 adapter as the data store.
      # Provided by the rosette-active-record gem.
      config.use_datastore('active-record', database_config_for_env)

      # Use resque as the commit processing queue. Provided by the
      # rosette-queue-resque gem.
      config.use_queue('resque')

      # Add a repo. The name passed in here is how Rosette will refer to this
      # repo, and should be unique.
      config.add_repo('rosette-demo-rails-app') do |repo|
        # The path on disk where your local clone lives. If this directory
        # doesn't exist, Rosette will *not* attempt to clone your repo for you.
        repo.set_path(File.join(workspace, 'rosette-demo-rails-app/.git'))

        # Set a basic description of this repo. Not used by Rosette, mostly this
        # exists for your records.
        repo.set_description('A test Rails app for demonstration purposes.')

        # Tell Rosette which locales this repo supports. Note that these are
        # made-up locales (pig latin and lolcat).
        repo.add_locales(%w(en-PL en-LC))

        # Tell Rosette which TMS (Translation Management System) to use. TMSs
        # are used to store and retrieve translations. You may want to consider
        # using a different TMS in production, since the filestore TMS stores
        # all translations locally on disk. Popular 3rd-party translation
        # management companies include Transifex and Smartling. The filestore
        # TMS is provided by the rosette-tms-filestore gem.
        repo.use_tms('filestore') do |tms_config|
          tms_config.set_store_path(tms_store_path)
        end

        # Add an extractor capable of reading Rails-style YAML files from
        # config/locales/en.yml. Provided by the rosette-extractor-yaml gem.
        repo.add_extractor('yaml/rails') do |extractor|
          extractor.set_conditions do |cond|
            cond.match_path('config/locales/en.yml')
          end
        end

        # Add a serializer capable of writing translations in Rails-style YAML
        # format. Note that you'll need to give your serializer a name (the
        # first argument) as well as provide the format (known as a serializer id).
        # Provided by the rosette-serializer-yaml gem.
        repo.add_serializer('rails', format: 'yaml/rails') do |serializer_config|
          # Tell the YAML serializer to run all translations through the
          # normalization pre-processor before serializing them. Provided by the
          # rosette-preprocessor-normalization gem.
          serializer_config.add_preprocessor('normalization') do |pre_config|
            # See the docs for the rosette-preprocessor-normalization gem for
            # a description of the various configuration options.
            pre_config.set_normalization_form(:nfc)
          end
        end
      end
    end
  end

  def self.tms_store_path
    @tms_store_path ||= File.expand_path('../../tms-store', __FILE__)
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
