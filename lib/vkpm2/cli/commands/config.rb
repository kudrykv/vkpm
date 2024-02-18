# frozen_string_literal: true

module VKPM2
  module CLI
    module Commands
      class Config < Thor
        desc 'list', 'List all the config variables'
        def list
          result = Interactors::InitializeConfig.call
          raise if result.failure?

          puts Presenters::Console::Config.new(result.config)
        end
      end
    end
  end
end
