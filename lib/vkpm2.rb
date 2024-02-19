# frozen_string_literal: true

require 'active_support/all'
require 'thor'
require 'zeitwerk'
require 'pastel'
require 'tty-config'
require 'tty-prompt'
require 'interactor'
require 'http'
require 'nokogiri'

require_relative 'vkpm2/version'

TTY::Pastel = Pastel

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  'vkpm2' => 'VKPM2',
  'cli' => 'CLI'
)
loader.setup

module VKPM2
  class Error < StandardError; end
end
