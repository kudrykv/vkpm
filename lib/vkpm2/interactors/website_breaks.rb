# frozen_string_literal: true

module VKPM2
  module Interactors
    class WebsiteBreaks
      include Interactor

      def call
        context.breaks = website.breaks(year:)
      end

      private

      def website
        raise Error, 'website not set' unless context.website

        context.website
      end

      def year
        raise Error, 'year not set' unless context.report_year

        context.report_year
      end
    end
  end
end
