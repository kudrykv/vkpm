# frozen_string_literal: true

module VKPM2
  module Adapters
    class Config
      ABSOLUTE_DIR = File.join(Dir.home, '.config', 'vkpm').freeze
      FILE = 'config.yaml'

      def initialize(client: Clients::Config.new)
        @client = client

        client.append_path(ABSOLUTE_DIR)
        config.filename = FILE

        config.write unless config.exist?
      end

      private

      attr_reader :client
    end
  end
end
