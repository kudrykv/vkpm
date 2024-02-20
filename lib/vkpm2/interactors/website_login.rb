# frozen_string_literal: true

module VKPM2
  module Interactors
    class WebsiteLogin
      include Interactor
      include Vars::Website

      def call
        context.config_key = 'auth.cookies'
        context.config_value = website.login(username, password).map(&:to_h).map(&:stringify_keys)
      end

      private

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
