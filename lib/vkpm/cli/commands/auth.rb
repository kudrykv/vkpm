# frozen_string_literal: true

module VKPM
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

          result = Organizers::AuthLogin.call(username:, password:)
          raise Error, result.error if result.failure?

          puts 'Logged in successfully'
        end

        private

        attr_reader :prompt
      end
    end
  end
end
