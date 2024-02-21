# frozen_string_literal: true

module VKPM
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
          report_entries.map { |entry| Line.new(entry:, holidays:, breaks:, pastel:) }.join("\n")
        end

        def month_name
          Date::MONTHNAMES[report_month]
        end

        class Line
          attr_reader :entry, :holidays, :breaks, :pastel

          def initialize(entry:, holidays:, breaks:, pastel:)
            @entry = entry
            @holidays = holidays
            @breaks = breaks
            @pastel = pastel
          end

          def to_s
            "#{overtime_signifier} #{id} > #{date}, #{project}, #{activity}, #{completeness}, #{duration}, #{entry.task.name}".strip
          end

          private

          def overtime_signifier
            return '' unless entry.overtime

            'OVERTIME'
          end

          def id
            return "<#{entry.id}>" if entry.can_edit

            "##{entry.id}"
          end

          def date
            entry.task.date.strftime('%b %d %a')
          end

          def activity
            entry.activity.name
          end

          def completeness
            "#{entry.task.status}%"
          end

          def project
            entry.project.name
          end

          def duration
            str = Tools::Chronic.human_readable_duration(entry.duration.in_minutes)
            starts_at = entry.task.starts_at.strftime('%H:%M')
            ends_at = entry.task.ends_at.strftime('%H:%M')

            "#{str} (#{starts_at} - #{ends_at})"
          end
        end
      end
    end
  end
end
