# frozen_string_literal: true

module VKPM
  module Interactors
    class WebsiteHolidays
      include Interactor
      include Vars::Website

      def call
        context.holidays = website.holidays_this_year
      end
    end
  end
end
