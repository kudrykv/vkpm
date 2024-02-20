# frozen_string_literal: true

module VKPM2
  module Interactors
    class ReportHours
      include Interactor

      def call
        website.report(report_entry)
      end

      private

      def report_entry
        raise Error, 'report_entry is not set' unless context.report_entry

        context.report_entry
      end

      def website
        raise Error, 'website is not set' unless context.website

        context.website
      end
    end
  end
end
