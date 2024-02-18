# frozen_string_literal: true

module VKPM2
  module Adapters
    class Config
      ABSOLUTE_DIR = File.join(Dir.home, '.config', 'vkpm').freeze
      FILE = 'config.yaml'

      def initialize(client: Clients::Config.new)
        @client = client

        client.append_path(ABSOLUTE_DIR)
        client.filename = FILE

        client.write unless client.exist?
        client.read
      end

      # @param [String] key
      def set(key, value)
        raise VKPM2::Error, "Invalid key: #{key}" unless ACCEPTABLE_KEYS.include?(key)

        client.set(key, value:)
      end

      def write
        client.write(force: true)
      end

      def backend_domain
        domain = client.fetch('backend.domain')
        raise Error, 'Backend domain is not set' if domain.nil?

        domain
      end

      def to_h
        ACCEPTABLE_KEYS.each_with_object({}) do |key, hash|
          hash[key[:name]] = client.fetch(key[:name])
          hash[key[:name]] = '********' if key[:sensitive] && hash[key[:name]]
        end
      end

      private

      attr_reader :client

      ACCEPTABLE_KEYS = [
        {name: 'backend.domain'},
        {name: 'auth.cookies', sensitive: true}
      ].freeze
      # ACCEPTABLE_KEYS = [backend.domain auth.cookies].freeze
    end
  end
end
