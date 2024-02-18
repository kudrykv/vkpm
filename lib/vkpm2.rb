# frozen_string_literal: true

require 'thor'
require 'zeitwerk'
require 'tty-config'
require 'interactor'

require_relative 'vkpm2/version'

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  'vkpm2' => 'VKPM2',
  'cli' => 'CLI'
)
loader.setup

module VKPM2
  class Error < StandardError; end
end
