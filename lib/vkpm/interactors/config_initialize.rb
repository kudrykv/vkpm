# frozen_string_literal: true

module VKPM
  module Interactors
    class ConfigInitialize
      include Interactor

      def call
        context.config = Adapters::Config.new
      end
    end
  end
end
