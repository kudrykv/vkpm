# frozen_string_literal: true

module VKPM2
  module Interactors
    class SetConfig
      include Interactor

      def call
        context.config.set(context.key, context.value)
      end
    end
  end
end
