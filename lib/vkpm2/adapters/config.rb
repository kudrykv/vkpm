# frozen_string_literal: true

module VKPM2
  module Adapters
    class Config
      def initialize(client: Clients::Config.new)
        @client = client
      end

      private

      attr_reader :client
    end
  end
end
