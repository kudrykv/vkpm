# frozen_string_literal: true

module VKPM
  module Interactors
    module Vars
      module ReportDate
        def report_date
          raise Error, '`report_date` is not set' unless context.report_date

          context.report_date
        end

        def year
          report_date.year
        end

        def month
          report_date.month
        end
      end
    end
  end
end
