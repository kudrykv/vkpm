# frozen_string_literal: true

module VKPM2
  module Presenters
    module Console
      class ReportedEntries
        attr_accessor :presenter

        def initialize(format)
          case format
          when 'simple'
            @presenter = ReportedEntriesSimple
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
