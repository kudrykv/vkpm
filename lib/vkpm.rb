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

require_relative 'vkpm/version'

TTY::Pastel = Pastel

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  'vkpm' => 'VKPM',
  'cli' => 'CLI'
)
loader.setup

module VKPM
  class Error < StandardError; end
end
