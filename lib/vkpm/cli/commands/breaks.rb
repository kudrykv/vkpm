# frozen_string_literal: true

module VKPM
  module CLI
    module Commands
      class Breaks < Thor
        desc 'show', 'Show breaks'
        option :report_date, type: :string, default: Date.today.strftime('%b %Y')
        def show
          puts 'nothing here yet'
        end
      end
    end
  end
end
