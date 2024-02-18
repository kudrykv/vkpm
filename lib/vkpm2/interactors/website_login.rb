# frozen_string_literal: true

module VKPM2
  module Interactors
    class WebsiteLogin
      include Interactor

      def call
        context.key = 'auth.cookies'
        context.value = website.login(username, password).map(&:to_h).map(&:stringify_keys)
      end

      private

      def website
        raise Error, 'website is required' unless context.website

        context.website
      end

      def username
        raise Error, 'username is required' unless context.username

        context.username
      end

      def password
        raise Error, 'password is required' unless context.password

        context.password
      end
    end
  end
end
