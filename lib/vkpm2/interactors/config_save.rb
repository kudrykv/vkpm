# frozen_string_literal: true

module VKPM2
  module Interactors
    class ConfigSave
      include Interactor
      include Vars::Configs

      def call
        config.write
      end
    end
  end
end
