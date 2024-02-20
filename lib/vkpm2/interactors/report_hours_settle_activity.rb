# frozen_string_literal: true

module VKPM2
  module Interactors
    class ReportHoursSettleActivity
      include Interactor

      def call
        guard_against_no_activity

        report_entry.activity = activity || default_activity
        return unless activity.id.nil?

        activities = website.available_activities
        matched_activities = activities.select { |a| a.name.downcase.include?(activity.name.downcase) }
        raise Error, 'ambiguous activity name' if matched_activities.size > 1
        raise Error, 'activity not found' if matched_activities.empty?

        report_entry.activity = matched_activities.first
      end

      private

      def guard_against_no_activity
        return unless activity.nil? && default_activity.nil?

        raise Error, 'no activity name specified nor default activity set'
      end

      def activity
        report_entry.activity
      end

      def report_entry
        raise Error, 'no report entry specified' unless context.report_entry

        context.report_entry
      end

      def default_activity
        config.default_activity
      end

      def config
        raise Error, 'no config specified' unless context.config

        context.config
      end

      def website
        raise Error, 'no website specified' unless context.website

        context.website
      end
    end
  end
end
