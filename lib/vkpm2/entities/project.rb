# frozen_string_literal: true

module VKPM2
  module Entities
    class Project
      attr_accessor :id, :name

      def initialize(id:, name:)
        @id = id
        @name = name
      end
    end
  end
end
