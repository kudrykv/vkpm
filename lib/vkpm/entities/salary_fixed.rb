# frozen_string_literal: true

module VKPM
  module Entities
    class SalaryFixed
      attr_accessor :amount

      def initialize(amount)
        self.amount = amount
      end
    end
  end
end
