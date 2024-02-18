# frozen_string_literal: true

module VKPM2
  module CLI
    module Commands
      class Auth < Thor
        def initialize(...)
          super(...)

          @prompt = TTY::Prompt.new
        end

        desc 'login', 'Login to VKPM'
        def login
          username = prompt.ask('Username:', required: true)
          password = prompt.mask('Password:', required: true)

          puts "Logging in as #{username}..."
          puts "Password: #{password}..."
        end

        private

        attr_reader :prompt
      end
    end
  end
end
