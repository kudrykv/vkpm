# frozen_string_literal: true

module VKPM
  module Interactors
    class ConfigSetKeyValue
      include Interactor
      include Vars::Configs

      def call
        config.set(config_key, config_value)
      end
    end
  end
end
