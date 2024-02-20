# frozen_string_literal: true

module VKPM2
  module Interactors
    module Vars
      module ReportEntry
        def report_entry
          raise Error, '`report_entry` is not set' unless context.report_entry

          context.report_entry
        end
      end
    end
  end
end
