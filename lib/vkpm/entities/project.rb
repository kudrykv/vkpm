# frozen_string_literal: true

module VKPM
  module Entities
    class Project
      attr_accessor :id, :name
      attr_reader :errors

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

      def ==(other)
        instance_of?(other.class) && id == other.id && name == other.name
      end
    end
  end
end
