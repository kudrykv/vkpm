# frozen_string_literal: true

module VKPM2
  module Entities
    class ReportEntry
      attr_accessor :id, :publish_date, :project, :activity, :task, :overtime, :source

      def initialize(id: nil, publish_date: nil, project:, activity:, task:, overtime: false, source: nil)
        @id = id
        @publish_date = publish_date
        @project = project
        @activity = activity
        @task = task
        @overtime = overtime
        @source = source
      end

      def duration
        task.duration
      end
    end
  end
end
