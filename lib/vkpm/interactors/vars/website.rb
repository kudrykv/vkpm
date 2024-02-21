# frozen_string_literal: true

module VKPM
  module Interactors
    module Vars
      module Website
        def website
          raise Error, '`website` is not set' unless context.website

          context.website
        end
      end
    end
  end
end
