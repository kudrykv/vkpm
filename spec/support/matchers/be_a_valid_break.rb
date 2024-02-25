# frozen_string_literal: true

RSpec::Matchers.define :be_a_valid_break do
  match do |actual|
    actual.is_a?(VKPM::Entities::Break) &&
      actual.id.present? &&
      actual.start_date.is_a?(Date) &&
      actual.end_date.is_a?(Date) &&
      actual.used_days.is_a?(Integer)
  end
end

