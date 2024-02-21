# frozen_string_literal: true

module VKPM
  module Interactors
    class Compensation
      include Interactor
      include Vars::Website
      include Vars::ReportDate

      def call
        context.compensation = website.compensation(report_date)
      end
    end
  end
end
