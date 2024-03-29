# frozen_string_literal: true

module VKPM
  module CLI
    module Commands
      class Config < Thor
        desc 'list', 'List all the config variables'
        def list
          result = Interactors::ConfigInitialize.call
          raise if result.failure?

          puts Presenters::Console::Config.new(result.config)
        end

        desc 'set', 'Set a config variable'
        method_option :key, type: :string, required: true
        method_option :value, type: :string, required: true
        def set
          result = Organizers::SetConfigValue.call(config_key: options[:key], config_value: options[:value])
          raise Error, result.error if result.failure?

          puts "Set #{options[:key]} to #{options[:value]}"
        end

        desc 'unset', 'Unset a config variable'
        method_option :key, type: :string, required: true
        def unset
          result = Organizers::UnsetConfigValue.call(config_key: options[:key])
          raise Error, result.error if result.failure?

          puts "Unset #{options[:key]}"
        end
      end
    end
  end
end
