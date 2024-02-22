# frozen_string_literal: true

module VKPM
  module CLI
    module Commands
      class Compensation < Thor
        desc 'check', 'Check compensation'
        option :report_date, type: :string, default: Date.today.to_s.split('-').first(2).reverse.join('-')
        def check
          result = Organizers::CompensationCheck.call(report_date:)
          raise Error, result.error if result.failure?

          puts Presenters::Console::Compensation.new(result.compensation)
        end

        private

        def report_date
          Date.parse(options[:report_date])
        end
      end
    end
  end
end
