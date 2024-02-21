# frozen_string_literal: true

module VKPM
  module Entities
    class Activity
      attr_accessor :id, :name, :errors

      def initialize(name:, id: nil)
        @id = id
        @name = name

        @errors = []
      end

      def valid?
        return false if errors.any?

        errors << 'id is required' if id.blank?

        errors.empty?
      end

      def similar?(other)
        instance_of?(other.class) && name.downcase == other.name.downcase
      end
    end
  end
end
