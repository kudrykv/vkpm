# frozen_string_literal: true

module VKPM2
  module Interactors
    class ReportHoursSettleTask
      include Interactor

      def call
        task.name ||= report_entry.project.name
        task.description ||= report_entry.project.name
        raise Error, task.errors.join(', ') unless task.valid?

        task.align(today_entries)
      end

      private

      def task
        report_entry.task
      end

      def report_entry
        raise Error, 'report entry is not set' unless context.report_entry

        context.report_entry
      end

      def today_entries
        reported_entries.select { |entry| entry.task.date == task.date }
      end

      def reported_entries
        raise Error, 'reported entries are not set' unless context.reported_entries

        context.reported_entries
      end
    end
  end
end
