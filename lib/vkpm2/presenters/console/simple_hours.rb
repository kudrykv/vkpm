# frozen_string_literal: true

module VKPM2
  module Presenters
    module Console
      class SimpleHours
        attr_reader :year, :month, :report_entries, :holidays, :breaks, :pastel

        def initialize(year:, month:, report_entries:, holidays:, breaks:, pastel: Adapters::Pastel.new)
          @year = year
          @month = month
          @report_entries = report_entries
          @holidays = holidays
          @breaks = breaks
          @pastel = pastel
        end

        def to_s
          <<~TEXT
            #{pastel.bold("# #{month_name} #{year}")}
            #{date_range.map(&method(:format_date_row)).join("\n")}

            Reported hours: #{human_readable_time(all_reported_minutes)}
          TEXT
        end

        private

        def month_name
          Date::MONTHNAMES[month]
        end

        def format_date_row(date)
          day_entries = report_entries
                          .select { |entry| entry.task.date == date }
                          .sort_by { |entry| entry.task.starts_at }

          blocks = day_entries.map(&method(:format_entry)).join(' ')

          minutes = day_entries.map { |entry| entry.duration.in_minutes }.sum
          time_for_day = format('(%-6s)', human_readable_time(minutes))

          today_holidays = holidays.select { |holiday| holiday.date == date }
          formatted_holidays = today_holidays.map(&:name).join(', ')

          having_break = breaks.any? { |a_break| a_break.active?(date) }
          formatted_break = having_break ? 'Break' : ''

          missing_report = date <= Date.today && day_entries.empty? && today_holidays.empty? && !having_break && !date.saturday? && !date.sunday?
          formatted_forgot = missing_report ? 'Forgot to report?' : ''

          line = [blocks, formatted_holidays, formatted_break, formatted_forgot].reject(&:blank?).join(' ')

          "#{date.strftime('%a %d')} #{time_for_day}: #{line}"
        end

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

        def all_reported_minutes
          report_entries.map { |entry| entry.duration.in_minutes }.sum
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
