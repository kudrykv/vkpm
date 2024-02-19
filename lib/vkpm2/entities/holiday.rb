# frozen_string_literal: true

module VKPM2
  module Entities
    class Holiday
      attr_accessor :date, :name

      def initialize(date:, name:)
        @date = date
        @name = name
      end
    end
  end
end