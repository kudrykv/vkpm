# frozen_string_literal: true

module VKPM2
  module Presenters
    module Console
      class SimpleHours
        attr_reader :year, :month, :report_entries

        def initialize(year:, month:, report_entries:)
          @year = year
          @month = month
          @report_entries = report_entries
        end

        def to_s
          <<~STR
            #{year} - #{month_name}
          STR
        end

        private

        def month_name
          Date::MONTHNAMES[month]
        end
      end
    end
  end
end
