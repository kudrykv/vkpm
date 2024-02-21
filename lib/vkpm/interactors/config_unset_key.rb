# frozen_string_literal: true

module VKPM
  module Interactors
    class ConfigUnsetKey
      include Interactor
      include Vars::Configs

      def call
        config.unset(config_key)
      end
    end
  end
end
