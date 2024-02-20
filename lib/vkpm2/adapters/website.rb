# frozen_string_literal: true

module VKPM2
  module Adapters
    class Website
      def initialize(client:)
        @client = client
      end

      def login(username, password)
        client.login(username, password)
      end

      def auth(cookies)
        client.auth(cookies)
      end

      def reported_entries(year:, month:)
        client.reported_entries(year:, month:)
      end

      def holidays_this_year
        client.holidays_this_year
      end

      def breaks(year:)
        client.breaks(year:)
      end

      def available_projects
        client.available_projects
      end

      def available_activities
        client.available_activities
      end

      private

      attr_reader :client
    end
  end
end
