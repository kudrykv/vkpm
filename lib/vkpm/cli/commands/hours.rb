# frozen_string_literal: true

module VKPM
  module CLI
    module Commands
      class Hours < Thor
        desc 'show', 'Show hours'
        option :report_date, type: :string, default: Date.today.to_s.split('-').first(2).reverse.join('-')
        option :format, type: :string, default: 'visual', enum: %w[visual one-line]
        def show
          result = Organizers::GetReportedEntries.call(report_year:, report_month:)
          raise Error, result.error if result.failure?

          puts Presenters::Console::ReportedEntries.new(options[:format]).present(
            report_year:,
            report_month:,
            report_entries: result.reported_entries,
            holidays: result.holidays,
            breaks: result.breaks
          )
        end

        desc 'report', 'Report hours'
        option :report_date, type: :string, aliases: '-d', desc: 'Report date', default: Date.today.to_s
        option :project_name, type: :string, aliases: '-p', desc: 'Project name'
        option :activity_name, type: :string, aliases: '-a', desc: 'Activity name'
        option :task_status, type: :numeric, aliases: '-s', desc: 'Task status', default: 100
        option :task_name, type: :string, aliases: '-t', desc: 'Task name'
        option :task_description, type: :string, aliases: '-e', desc: 'Task description'
        option :start_time, type: :string, aliases: '-b', desc: 'Start time'
        option :end_time, type: :string, aliases: '-f', desc: 'End time'
        option :span, type: :string, aliases: '-m', desc: 'Span'
        option :overtime, type: :boolean, desc: 'Overtime', default: false
        def report
          result = Organizers::ReportHours.call(report_entry:, report_year:, report_month:)
          raise Error, result.error if result.failure?

          puts Presenters::Console::ReportedEntry.new(result.reported_entry)
        end

        desc 'delete', 'Delete hours'
        option :id, type: :string, aliases: '-i', desc: 'Reported entry id'
        def delete
          result = Organizers::DeleteReportedEntry.call(entry_id: options[:id])
          raise Error, result.error if result.failure?

          puts 'Deleted.'
        end

        private

        def year
          options[:year]
        end

        def month
          options[:month]
        end

        def report_year
          report_date&.year
        end

        def report_month
          report_date&.month
        end

        def report_entry
          Entities::ReportEntry.new(project:, activity:, task:, overtime:)
        end

        def project
          return nil unless options[:project_name]

          Entities::Project.new(name: options[:project_name])
        end

        def activity
          return nil unless options[:activity_name]

          Entities::Activity.new(name: options[:activity_name])
        end

        def task
          Entities::Task.new(
            name: options[:task_name],
            description: options[:task_description],
            status: options[:task_status],
            date: report_date,
            starts_at: options[:start_time],
            ends_at: options[:end_time],
            span: parse_duration(options[:span]),
          )
        end

        def overtime
          options[:overtime]
        end

        def report_date
          return nil unless options[:report_date]

          Date.parse(options[:report_date])
        end

        # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        def parse_duration(str)
          return nil unless str

          hours = str.scan(/(\d+)h/).first&.first&.to_i || 0
          minutes = str.scan(/(\d+)m/).first&.first&.to_i || 0
          seconds = str.scan(/(\d+)s/).first&.first&.to_i || 0

          ((hours * 3600) + (minutes * 60) + seconds).seconds
        end
        # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      end
    end
  end
end
