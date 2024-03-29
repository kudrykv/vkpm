# frozen_string_literal: true

module VKPM
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

      def report(report_entry)
        client.report(report_entry)
      end

      def delete_reported_entry(id)
        client.delete_reported_entry(id)
      end

      def compensation(report_date)
        client.compensation(report_date)
      end

      private

      attr_reader :client
    end
  end
end
