# frozen_string_literal: true

require_relative 'vkpm2/version'

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  'vkpm2' => 'VKPM2',
  'cli' => 'CLI'
)
loader.setup

module Vkpm2
  class Error < StandardError; end
end
