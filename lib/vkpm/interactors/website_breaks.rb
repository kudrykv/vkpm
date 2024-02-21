# frozen_string_literal: true

module VKPM
  module Interactors
    class WebsiteBreaks
      include Interactor
      include Vars::Website
      include Vars::ReportDate

      def call
        context.breaks = website.breaks(year:)
      end
    end
  end
end
