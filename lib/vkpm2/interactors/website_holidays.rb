# frozen_string_literal: true

module VKPM2
  module Interactors
    class WebsiteHolidays
      include Interactor

      def call
        context.holidays = website.holidays_this_year
      end

      def website
        raise Error, 'website not set' unless context.website

        context.website
      end
    end
  end
end
