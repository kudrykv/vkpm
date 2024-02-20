# frozen_string_literal: true

module VKPM2
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
