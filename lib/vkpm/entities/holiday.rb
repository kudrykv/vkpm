# frozen_string_literal: true

module VKPM
  module Entities
    class Holiday
      attr_accessor :date, :name

      def initialize(date:, name:)
        @date = date
        @name = name
      end

      def ==(other)
        instance_of?(other.class) &&
          date == other.date &&
          name == other.name
      end
    end
  end
end
