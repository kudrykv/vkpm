# frozen_string_literal: true

module VKPM2
  module Clients
    class Website
      def initialize(domain:)
        @domain = domain
        @auth_cookies = {}
      end

      def login(username, password)
        csrf_cookie = initial_csrf_cookie
        cookies = HTTP::CookieJar.new.add(csrf_cookie)
        form = login_form(username, password, csrf_cookie)

        response = HTTP.cookies(cookies).post("#{domain}/login/", form:, headers:)
        raise Error, error_message(response) if response.status == 200

        response.cookies.to_a.map { |cookie| Entities::Cookie.new(cookie.name, cookie.value) }
      end

      def auth(cookies)
        @auth_cookies = cookies.reduce({}) { |acc, cookie| acc.merge(cookie.name => cookie.value) }
      end

      def reported_entries(year:, month:)
        response = auth_http.post("#{domain}/history/", form: { year:, month: })

        Models::ReportEntry.from_html(response.body.to_s)
      end

      def holidays_this_year
        enable_all_blocks_in_dashboard

        response = auth_http.get("#{domain}/dashboard/block/holiday_block/")

        Models::Holiday.from_html(response.body.to_s)
      end

      def breaks(year:)
        response = auth_http.post("#{domain}/breaks/", form: { year:, type: 'v', year_changed: 'true' })

        Models::Break.from_html(response.body.to_s)
      end

      def available_projects
        response = auth_http.get("#{domain}/report/")

        Models::Project.from_html(response.body.to_s)
      end

      private

      attr_reader :domain, :auth_cookies

      def enable_all_blocks_in_dashboard
        uri = "#{domain}/dashboard/"
        response = auth_http.get(uri)
        dashboard_id = Nokogiri.parse(response.body.to_s).xpath('//input[@name="id"]').attr('value').to_s

        form = csrf_form.merge(
          id: dashboard_id,
          user_salary_block: 'on',
          birthdays_block: 'on',
          devices_block: 'on',
          holiday_block: 'on',
          users_block: 'on'
        )

        auth_http.post("#{uri}/update/", form: form)
      end

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

      def csrf_form
        return {} unless csrf

        { csrfmiddlewaretoken: csrf }
      end

      def auth_http
        HTTP.cookies(**auth_cookies).headers(headers)
      end

      def headers
        { Accept: '*/*', Referer: "#{domain}/login/" }.merge(csrf_header)
      end

      def csrf_header
        return {} unless csrf

        { 'X-CSRFToken' => csrf }
      end

      def csrf
        auth_cookies['csrftoken']
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
