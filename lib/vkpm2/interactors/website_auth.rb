# frozen_string_literal: true

module VKPM2
  module Interactors
    class WebsiteAuth
      include Interactor

      def call
        website.auth(cookies)
      end

      private

      def website
        raise Error, 'site is not defined' unless context.website

        context.website
      end

      def cookies
        raise Error, 'cookies is not defined' unless config.auth_cookies

        config.auth_cookies
      end

      def config
        raise Error, 'config is not defined' unless context.config

        context.config
      end
    end
  end
end
