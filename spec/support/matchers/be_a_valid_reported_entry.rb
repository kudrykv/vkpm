# frozen_string_literal: true

def report_entry_looks_good?(entry)
  entry.is_a?(VKPM::Entities::ReportEntry) &&
    entry.id.present? &&
    entry.publish_date.present? &&
    entry.publish_date.is_a?(Time) &&
    entry.project.present? &&
    entry.activity.present? &&
    entry.task.present?
end

def project_looks_good?(project)
  project.is_a?(VKPM::Entities::Project) &&
    project.name.present?
end

def activity_looks_good?(activity)
  activity.is_a?(VKPM::Entities::Activity) &&
    activity.id.present? &&
    activity.name.present?
end

def task_looks_good?(task)
  task.is_a?(VKPM::Entities::Task) &&
    task.name.present? &&
    task.description.present? &&
    !task.status.nil? &&
    task.date.present? &&
    task.starts_at.present? &&
    task.ends_at.present?
end

RSpec::Matchers.define :be_a_valid_reported_entry do
  match do |actual|
    return false unless report_entry_looks_good?(actual)
    return false unless project_looks_good?(actual.project)
    return false unless activity_looks_good?(actual.activity)
    return false unless task_looks_good?(actual.task)

    true
  end
end
