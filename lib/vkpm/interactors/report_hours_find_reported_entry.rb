# frozen_string_literal: true

module VKPM
  module Interactors
    class ReportHoursFindReportedEntry
      include Interactor
      include Vars::ReportEntry
      include Vars::ReportedEntries

      def call
        context.reported_entry = reported_entries.find { |entry| entry.similar?(report_entry) }
        raise Error, 'Likely reported, but could not find similar entry' unless context.reported_entry
      end
    end
  end
end
