# frozen_string_literal: true

module VKPM
  module Interactors
    class WebsitePullReportedEntries
      include Interactor
      include Vars::Website

      def call
        context.reported_entries = website.reported_entries(year:, month:)
      end

      private

      def year
        raise Error, 'year is not set' unless context.report_year

        context.report_year
      end

      def month
        raise Error, 'month is not set' unless context.report_month

        context.report_month
      end
    end
  end
end
