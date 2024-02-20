# frozen_string_literal: true

module VKPM2
  module Interactors
    class WebsiteAuth
      include Interactor
      include Vars::Configs
      include Vars::Website

      def call
        website.auth(cookies)
      end

      private

      def cookies
        raise Error, 'you are not authed' unless config.auth_cookies

        config.auth_cookies
      end
    end
  end
end
