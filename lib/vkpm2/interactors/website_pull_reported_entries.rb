# frozen_string_literal: true

module VKPM2
  module Interactors
    class WebsitePullReportedEntries
      include Interactor

      def call
        context.reported_entries = website.reported_entries(year: context.history_year, month: context.history_month)
      end

      private

      def website
        raise Error, 'website is not set' unless context.website

        context.website
      end
    end
  end
end
