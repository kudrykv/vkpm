# frozen_string_literal: true

module VKPM
  module Interactors
    class ReportHoursSettleProject
      include Interactor
      include Vars::Configs
      include Vars::Website
      include Vars::ReportEntry

      def call
        guard_against_no_project

        report_entry.project = project || default_project
        return unless project.id.nil?

        report_entry.project = matched_project
      end

      private

      def guard_against_no_project
        return unless project.nil? && default_project.nil?

        raise Error, 'no project name specified nor default project set'
      end

      def project
        report_entry.project
      end

      def default_project
        config.default_project
      end

      def matched_project
        raise Error, ambiguous_project_name if matched_projects.size > 1
        raise Error, not_found if matched_projects.empty?

        matched_projects.first
      end

      def ambiguous_project_name
        "ambiguous project name `#{project.name}` matched #{matched_projects.map(&:name).join(', ')}"
      end

      def not_found
        "project `#{project.name}` not found"
      end

      def matched_projects
        @matched_projects ||= available_projects.select { |p| p.name.downcase.include?(project.name.downcase) }
      end

      def available_projects
        @available_projects ||= website.available_projects
      end
    end
  end
end
