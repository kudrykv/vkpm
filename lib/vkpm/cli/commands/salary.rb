# frozen_string_literal: true

module VKPM
  module CLI
    module Commands
      class Salary < Thor
        desc 'check', 'Check salary'
        option :report_date, type: :string, default: Date.today.to_s.split('-').first(2).reverse.join('-')
        def check
          result = Organizers::SalaryCheck.call()
        end
      end
    end
  end
end
