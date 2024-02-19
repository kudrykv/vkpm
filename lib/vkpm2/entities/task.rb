# frozen_string_literal: true

module VKPM2
  module Entities
    class Task
      attr_accessor :name, :description, :status, :date, :starts_at, :ends_at

      def initialize(name:, description:, status:, date:, starts_at:, ends_at:)
        @name = name
        @description = description
        @status = status
        @date = date
        @starts_at = starts_at
        @ends_at = ends_at
      end
    end
  end
end
