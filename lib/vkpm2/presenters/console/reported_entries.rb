# frozen_string_literal: true

module VKPM2
  module Presenters
    module Console
      class ReportedEntries
        attr_accessor :presenter

        def initialize(format)
          case format
          when 'visual'
            self.presenter = ReportedEntriesVisual
          when 'one-line'
            self.presenter = ReportedEntriesOneLine
          else
            raise Error, "Unknown format: #{format}"
          end
        end

        def present(...)
          presenter.new(...)
        end
      end
    end
  end
end
