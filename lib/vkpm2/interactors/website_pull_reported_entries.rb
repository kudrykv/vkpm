# frozen_string_literal: true

module VKPM2
  module Interactors
    class WebsitePullReportedEntries
      include Interactor

      def call
        context.reported_entries = website.reported_entries(year:, month:)
      end

      private

      def website
        raise Error, 'website is not set' unless context.website

        context.website
      end

      def year
        raise Error, 'year is not set' unless context.history_year

        context.report_year
      end

      def month
        raise Error, 'month is not set' unless context.history_month

        context.report_month
      end
    end
  end
end
