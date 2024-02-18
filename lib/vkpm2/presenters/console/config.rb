# frozen_string_literal: true

module VKPM2
  module Presenters
    module Console
      class Config
        def initialize(config)
          @config = config
        end

        def to_s
          'this will be the config presenter for the console interface'
        end

        private

        attr_reader :config
      end
    end
  end
end
