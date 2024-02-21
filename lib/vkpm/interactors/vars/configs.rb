# frozen_string_literal: true

module VKPM
  module Interactors
    module Vars
      module Configs
        def config
          raise Error, '`config` is not set' unless context.config

          context.config
        end

        def config_key
          raise Error, '`config_key` is not set' unless context.config_key

          context.config_key
        end

        def config_value
          raise Error, '`config_value` is not set' unless context.config_value

          context.config_value
        end
      end
    end
  end
end
