# frozen_string_literal: true

RSpec::Matchers.define :be_a_valid_project do
  match do |actual|
    actual.is_a?(VKPM::Entities::Project) &&
      actual.id.present? &&
      actual.name.present?
  end
end

