# frozen_string_literal: true

module VKPM2
  module Interactors
    class ReportHoursSettleProject
      include Interactor

      def call
        guard_against_no_project

        report_entry.project = default_project if project.nil?
        return unless project.id.nil?

        matched_projects = website.available_projects.select { |p| p.name.downcase.include?(project.name.downcase) }
        raise Error, 'ambiguous project name' if matched_projects.size > 1
        raise Error, 'project not found' if matched_projects.empty?

        report_entry.project = matched_projects.first
      end

      private

      def guard_against_no_project
        return unless project.nil? && default_project.nil?

        context.fail!(message: 'no project name specified nor default project set')
      end

      def project
        report_entry.project
      end

      def report_entry
        raise Error, 'report_entry is required' unless context.report_entry

        context.report_entry
      end

      def default_project
        config.default_project
      end

      def config
        raise Error, 'config is required' unless context.config

        context.config
      end

      def website
        raise Error, 'website is required' unless context.website

        context.website
      end
    end
  end
end
