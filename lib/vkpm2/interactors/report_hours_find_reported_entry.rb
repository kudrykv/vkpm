# frozen_string_literal: true

module VKPM2
  module Interactors
    class ReportHoursFindReportedEntry
      include Interactor

      def call
        context.reported_entry = reported_entries.find { |entry| entry.similar?(report_entry) }
        raise 'Likely reported, but could not find similar entry' unless context.reported_entry
      end

      private

      def report_entry
        raise Error, 'report entry is not set' unless context.report_entry

        context.report_entry
      end

      def reported_entries
        raise Error, 'reported entries is not set' unless context.reported_entries

        context.reported_entries
      end
    end
  end
end
