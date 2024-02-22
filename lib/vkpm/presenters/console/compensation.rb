# frozen_string_literal: true

module VKPM
  module Presenters
    module Console
      class Compensation
        attr_reader :compensation

        def initialize(compensation)
          @compensation = compensation
        end

        def to_s
          "#{date} - #{compensation.currency}#{compensation.amount}/#{compensation.interval} gross"
        end

        private

        def date
          compensation.date.strftime('%Y %B')
        end
      end
    end
  end
end
