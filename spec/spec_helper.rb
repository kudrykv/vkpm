# frozen_string_literal: true

require 'vkpm'
require 'rspec'
require 'vcr'
require 'webmock/rspec'
require 'uri/http'

require_relative 'support/vcr'

require_relative 'support/matchers/be_a_valid_reported_entry'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
