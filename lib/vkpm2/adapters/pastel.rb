# frozen_string_literal: true

module VKPM2
  module Adapters
    class Pastel
      attr_reader :client

      def initialize(client: Clients::Pastel.new)
        @client = client
      end

      def respond_to_missing?(...)
        client.respond_to?(...)
      end

      def method_missing(...)
        client.send(...)
      end
    end
  end
end
