# frozen_string_literal: true

module VKPM
  module Entities
    class Compensation
      attr_accessor :date, :compensation

      def initialize(date:, compensation:)
        self.date = date
        self.compensation = compensation
      end

      def amount
        compensation.amount
      end

      def interval
        compensation.interval
      end

      def currency
        '$'
      end
    end
  end
end
