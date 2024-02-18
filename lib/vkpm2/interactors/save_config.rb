# frozen_string_literal: true

module VKPM2
  module Interactors
    class SaveConfig
      include Interactor

      def call
        context.config.write
      end
    end
  end
end
