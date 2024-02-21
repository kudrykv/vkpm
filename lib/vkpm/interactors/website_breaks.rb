# frozen_string_literal: true

module VKPM
  module Interactors
    class WebsiteBreaks
      include Interactor
      include Vars::Website

      def call
        context.breaks = website.breaks(year:)
      end

      private

      def year
        raise Error, 'year not set' unless context.report_year

        context.report_year
      end
    end
  end
end
