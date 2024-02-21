# frozen_string_literal: true

module VKPM
  module Entities
    class Compensation
      attr_accessor :date, :compensation

      def initialize(date:, compensation:)
        self.date = date
        self.compensation = compensation
      end
    end
  end
end
