# frozen_string_literal: true

module VKPM2
  module Presenters
    module Console
      class ReportedEntriesOneLine
        attr_reader :report_year, :report_month, :report_entries, :holidays, :breaks, :pastel

        def initialize(report_year:, report_month:, report_entries:, holidays:, breaks:, pastel: Adapters::Pastel.new)
          @report_year = report_year
          @report_month = report_month
          @report_entries = report_entries
          @holidays = holidays
          @breaks = breaks
          @pastel = pastel
        end

        def to_s
          report_entries.map do |entry|
            "#{entry.id} #{entry.task.date.strftime('%a %d')} #{entry.project.name} #{entry.activity.name} #{entry.task.span}"
          end.join("\n")
        end
      end
    end
  end
end
