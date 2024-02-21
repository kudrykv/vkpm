# frozen_string_literal: true

module VKPM
  module Adapters
    class Prompt
      def initialize(client: Clients::Prompt.new)
        @client = client
      end

      def ask(question, required: true)
        client.ask(question, required:)
      end

      def mask(question, required: true)
        client.mask(question, required:)
      end

      private

      attr_reader :client
    end
  end
end
