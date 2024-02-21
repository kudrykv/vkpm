# frozen_string_literal: true

module VKPM
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
