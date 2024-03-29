# frozen_string_literal: true

module VKPM
  module Adapters
    class Config
      ABSOLUTE_DIR = File.join(Dir.home, '.config', 'vkpm').freeze
      FILE = 'config.yaml'

      def initialize(client: Clients::Config.new)
        @client = client

        client.append_path(ABSOLUTE_DIR)
        client.filename = FILE

        write unless client.exist?
        client.read
      end

      # @param [String] key
      def set(key, value)
        raise VKPM::Error, "Invalid key: #{key}" unless ACCEPTABLE_KEYS.map { |entry| entry[:name] }.include?(key)

        client.set(key, value:)
        client.write
      end

      def unset(key)
        raise VKPM::Error, "Invalid key: #{key}" unless ACCEPTABLE_KEYS.map { |entry| entry[:name] }.include?(key)

        client.delete(key)
        client.write
      end

      def backend_domain
        client.fetch('backend.domain')
      end

      def auth_cookies
        cookies = client.fetch('auth.cookies')
        return if cookies.nil?

        cookies.map { |cookie| Entities::Cookie.new(cookie['name'], cookie['value']) }
      end

      def default_project
        project = client.fetch('default.project')
        return nil if project.nil?

        Entities::Project.new(id: project['id'], name: project['name'])
      end

      def default_activity
        activity = client.fetch('default.activity')
        return nil if activity.nil?

        Entities::Activity.new(id: activity['id'], name: activity['name'])
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
        { name: 'backend.domain' },
        { name: 'auth.cookies', sensitive: true },

        { name: 'default.project.name' },
        { name: 'default.activity.name' }

      ].freeze

      def write
        client.write(force: true, create: true)
      end
    end
  end
end
