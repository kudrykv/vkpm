# frozen_string_literal: true

module VKPM2
  module Interactors
    class ConfigSave
      include Interactor

      def call
        config.write
      end

      private

      def config
        raise Error, 'config is not set' unless context.config

        context.config
      end
    end
  end
end