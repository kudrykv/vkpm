# frozen_string_literal: true

module VKPM
  module Entities
    class MonthSummary
      attr_reader :salary,
                  :reported_hours,
                  :working_hours,
                  :paid_break_hours,
                  :unpaid_break_hours
    end
  end
end
