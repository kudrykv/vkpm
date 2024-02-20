# frozen_string_literal: true

module VKPM2
  module Interactors
    class ReportHoursSettleTask
      include Interactor
      include Vars::ReportEntry
      include Vars::ReportedEntries

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

      def today_entries
        reported_entries.select { |entry| entry.task.date == task.date }
      end
    end
  end
end
