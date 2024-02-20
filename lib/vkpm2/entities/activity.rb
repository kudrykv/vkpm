# frozen_string_literal: true

module VKPM2
  module Entities
    class Activity
      attr_accessor :id, :name
      attr_accessor :errors

      def initialize(id: nil, name:)
        @id = id
        @name = name

        @errors = []
      end

      def valid?
        return false if errors.any?

        errors << 'id is required' if id.blank?

        errors.empty?
      end
    end
  end
end
