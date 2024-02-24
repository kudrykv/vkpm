# frozen_string_literal: true

module VKPM
  module Entities
    class ReportEntry
      attr_accessor :id, :publish_date, :project, :activity, :task, :overtime, :can_edit, :source, :errors

      def initialize(project:, activity:, task:, id: nil, publish_date: nil, overtime: false, can_edit: false,
                     source: nil)
        self.id = id
        self.publish_date = publish_date
        self.project = project
        self.activity = activity
        self.task = task
        self.overtime = overtime
        self.can_edit = can_edit
        self.source = source

        self.errors = []
      end

      def valid?
        return false if errors.any?

        validate_project
        validate_activity
        validate_task

        errors.empty?
      end

      def duration
        task.duration
      end

      def similar?(other)
        instance_of?(other.class) &&
          project.similar?(other.project) &&
          activity.similar?(other.activity) &&
          task.similar?(other.task) &&
          overtime == other.overtime
      end

      private

      def validate_project
        return errors << 'project is not set' if project.nil?

        errors.append(project.errors) unless project.valid?
      end

      def validate_activity
        return errors << 'activity is not set' if activity.nil?

        errors.append(activity.errors) unless activity.valid?
      end

      def validate_task
        return errors << 'task is not set' if task.nil?

        errors.append(task.errors) unless task.valid?
      end
    end
  end
end
