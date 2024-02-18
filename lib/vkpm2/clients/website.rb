# frozen_string_literal: true

module VKPM2
  module Clients
    class Website
      def initialize(domain:)
        @domain = domain
        @auth_cookies = []
      end

      def login(username, password)
        csrf_cookie = initial_csrf_cookie
        cookies = HTTP::CookieJar.new.add(csrf_cookie)
        form = login_form(username, password, csrf_cookie)

        response = HTTP.cookies(cookies).post("#{domain}/login/", form:, headers:)
        raise Error, error_message(response) if response.status == 200

        response.cookies.to_a.map { |cookie| Entities::Cookie.new(cookie.name, cookie.value) }
      end

      private

      attr_reader :domain, :auth_cookies

      def initial_csrf_cookie
        response = HTTP.get("#{domain}/login/")
        cookie = response.cookies.to_a.find { |c| c.name == 'csrftoken' }

        raise Error, 'Could not find csrf token' unless cookie

        cookie
      end

      def login_form(username, password, csrf_cookie)
        {
          csrfmiddlewaretoken: csrf_cookie.value,
          username:,
          password:
        }
      end

      def headers
        { Accept: '*/*', Referer: "#{domain}/login/" }.merge(csrf_header)
      end

      def csrf_header
        csrf_cookie = auth_cookies.find { |cookie| cookie.name == 'csrftoken' }
        return {} unless csrf_cookie

        { 'X-CSRFToken' => csrf_cookie.value }
      end

      def error_message(response)
        Nokogiri
          .parse(response.body.to_s)
          .xpath('//*[contains(@class, "errorlist")]')
          .children
          .last
          .text
      rescue StandardError => e
        "An error occurred while parsing the error message: #{e.message}"
      end
    end
  end
end
