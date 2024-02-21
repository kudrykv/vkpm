# frozen_string_literal: true

module VKPM
  module Interactors
    class ReportHours
      include Interactor
      include Vars::Website
      include Vars::ReportEntry

      def call
        website.report(report_entry)
      end
    end
  end
end
