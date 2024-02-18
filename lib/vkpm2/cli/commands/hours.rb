# frozen_string_literal: true

module VKPM2
  module CLI
    module Commands
      class Hours < Thor
        desc 'show', 'Show hours'
        def show
          puts 'Hours'
        end
      end
    end
  end
end
