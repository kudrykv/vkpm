# frozen_string_literal: true

module VKPM2
  module Interactors
    class ReportHoursSettleActivity
      include Interactor
      include Vars::Configs
      include Vars::Website
      include Vars::ReportEntry

      def call
        guard_against_no_activity

        report_entry.activity = activity || default_activity
        return unless activity.id.nil?

        report_entry.activity = matched_activity
      end

      private

      def guard_against_no_activity
        return unless activity.nil? && default_activity.nil?

        raise Error, 'no activity name specified nor default activity set'
      end

      def activity
        report_entry.activity
      end

      def default_activity
        config.default_activity
      end

      def matched_activity
        raise Error, message_ambiguity if matched_activities.size > 1
        raise Error, message_not_found if matched_activities.empty?

        matched_activities.first
      end

      def message_ambiguity
        "ambiguous activity name `#{activity.name}` -- matched #{matched_activities.map(&:name).join(', ')}"
      end

      def message_not_found
        "activity `#{activity.name}` not found. Available are #{activities.map(&:name).join(', ')}"
      end

      def matched_activities
        @matched_activities ||= activities.select { |a| a.name.downcase.include?(activity.name.downcase) }
      end

      def activities
        @activities ||= website.available_activities
      end
    end
  end
end
