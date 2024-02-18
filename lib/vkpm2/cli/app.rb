# frozen_string_literal: true

module VKPM2
  module CLI
    class App < Thor
      def self.exit_on_failure?
        true
      end

      desc 'config', 'Configure vkpm'
      subcommand 'config', Commands::Config

      desc 'auth', 'Authenticate with vkpm'
      subcommand 'auth', Commands::Auth

      desc 'hours', 'Manage hours'
      subcommand 'hours', Commands::Hours
    end
  end
end
