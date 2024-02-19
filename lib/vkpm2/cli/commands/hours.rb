# frozen_string_literal: true

module VKPM2
  module CLI
    module Commands
      class Hours < Thor
        desc 'show', 'Show hours'

        option :year, type: :numeric, default: Time.now.year
        option :month, type: :numeric, default: Time.now.month
        def show
          result = Organizers::GetReportedEntries.call(history_year: options[:year], history_month: options[:month])
          raise Error, result.error if result.failure?
        end
      end
    end
  end
end
