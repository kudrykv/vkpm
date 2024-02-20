# frozen_string_literal: true

module VKPM2
  module Interactors
    class ConfigUnsetKey
      include Interactor

      def call
        config.unset(config_key)
      end

      private

      def config_key
        raise Error, 'config_key is required' unless context.config_key

        context.config_key
      end

      def config
        raise Error, 'config is required' unless context.config

        context.config
      end
    end
  end
end
