# frozen_string_literal: true

module VKPM2
  module Entities
    class Config
      attr_accessor :config

      def new
        @config = {}
      end
    end
  end
end
