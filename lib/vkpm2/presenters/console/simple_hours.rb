# frozen_string_literal: true

module VKPM2
  module Presenters
    module Console
      class SimpleHours
        attr_reader :year, :month, :report_entries, :pastel

        def initialize(year:, month:, report_entries:, pastel: Adapters::Pastel.new)
          @year = year
          @month = month
          @report_entries = report_entries
          @pastel = pastel
        end

        def to_s
          date_range.map do |date|
            day_entries = report_entries
                    .select { |entry| entry.task.date == date }
                    .sort_by { |entry| entry.task.starts_at }
            blocks = day_entries.map(&method(:format_entry)).join(' ')
            minutes = day_entries.map { |entry| entry.duration.in_minutes }.sum

            time_for_day = format('(%-6s)', human_readable_time(minutes))
            "#{date.strftime('%a %d')} #{time_for_day}: #{blocks}"
          end.join("\n")
        end

        private

        def date_range
          start_of_month = Date.new(year, month, 1)
          end_of_month = start_of_month.end_of_month

          (start_of_month..end_of_month)
        end

        def format_entry(entry)
          size = (entry.duration.in_minutes / 10).to_i

          block_text = "#{human_readable_time(entry.duration.in_minutes)}, #{entry.project.name}"
          block_format = format("%-#{size}.#{size}s", block_text)
          pastel.underscore(block_format)
        end

        def human_readable_time(minutes)
          [[60, :m], [Float::INFINITY, :h]].map do |count, name|
            minutes, number = minutes.divmod(count)
            "#{number.to_i}#{name}" unless number.to_i.zero?
          end.compact.reverse.join
        end
      end
    end
  end
end
