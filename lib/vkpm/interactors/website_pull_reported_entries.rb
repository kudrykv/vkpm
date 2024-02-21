# frozen_string_literal: true

module VKPM
  module Interactors
    class WebsitePullReportedEntries
      include Interactor
      include Vars::Website
      include Vars::ReportDate

      def call
        context.reported_entries = website.reported_entries(year:, month:)
      end
    end
  end
end
