# frozen_string_literal: true

module VKPM
  module Entities
    class SalaryRate
      attr_accessor :rate

      def initialize(rate)
        self.rate = rate
      end
    end
  end
end
