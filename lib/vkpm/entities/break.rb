# frozen_string_literal: true

module VKPM
  module Entities
    class Break
      attr_reader :id, :start_date, :end_date, :used_days, :approved, :paid

      def initialize(id:, start_date:, end_date:, used_days:, approved:, paid:)
        @id = id
        @start_date = start_date
        @end_date = end_date
        @used_days = used_days
        @approved = approved
        @paid = paid
      end

      def active?(date)
        date >= start_date && date <= end_date
      end
    end
  end
end
