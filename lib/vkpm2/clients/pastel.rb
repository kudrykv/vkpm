# frozen_string_literal: true

module VKPM2
  module Clients
    class Pastel
      attr_reader :client

      def initialize(client: TTY::Pastel.new)
        @client = client
      end

      def respond_to_missing?(...)
        client.respond_to?(...)
      end

      def method_missing(...)
        client.send(...)
      end

      private

      attr_reader :client
    end
  end
end
