# frozen_string_literal: true

module VKPM
  module Entities
    class CompensationRate
      attr_accessor :amount

      def initialize(amount)
        self.amount = amount
      end

      def interval
        'hour'
      end
    end
  end
end
