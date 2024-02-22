# frozen_string_literal: true

module VKPM
  module Entities
    class CompensationFixed
      attr_accessor :amount

      def initialize(amount)
        self.amount = amount
      end

      def interval
        'month'
      end
    end
  end
end
