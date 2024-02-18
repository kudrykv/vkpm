# frozen_string_literal: true

module VKPM2
  module Interactors
    class ConfigSetKeyValue
      include Interactor

      def call
        context.config.set(context.config_key, context.config_value)
      end
    end
  end
end
