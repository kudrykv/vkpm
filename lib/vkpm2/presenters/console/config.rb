# frozen_string_literal: true

module VKPM2
  module Presenters
    module Console
      class Config
        def initialize(config)
          @config = config
        end

        def to_s
          config
            .to_h
            .sort_by { |key, _value| key }
            .map { |row| "#{row[0]}: #{row[1]}" }
            .join("\n")
        end

        private

        attr_reader :config
      end
    end
  end
end
