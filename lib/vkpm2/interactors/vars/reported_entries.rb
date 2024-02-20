# frozen_string_literal: true

module VKPM2
  module Interactors
    module Vars
      module ReportedEntries
        def reported_entries
          raise Error, '`reported_entries` is not set' unless context.reported_entries

          context.reported_entries
        end
      end
    end
  end
end
