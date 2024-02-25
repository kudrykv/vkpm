# frozen_string_literal: true

module VKPM
  module Clients
    # rubocop:disable Metrics/ClassLength
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
        raise BadCredentialsError, error_message(response) if response.status == 200

        response.cookies.to_a.map { |cookie| Entities::Cookie.new(cookie.name, cookie.value) }
      end

      def auth(cookies)
        @auth_cookies = cookies.reduce({}) { |acc, cookie| acc.merge(cookie.name => cookie.value) }
      end

      def reported_entries(year:, month:)
        response = auth_http.post("#{domain}/history/", form: { year:, month: })

        history_entries = Models::ReportEntry.from_html(response.body.to_s)

        response = auth_http.get("#{domain}/report/")

        editable_ids = Models::ReportEntry.from_report_html_editable_ids(response.body.to_s)

        history_entries.each do |entry|
          entry.can_edit = editable_ids.include?(entry.id)
        end
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

      def available_activities
        response = auth_http.get("#{domain}/report/")

        Models::Activity.from_html(response.body.to_s)
      end

      def report(report_entry)
        raise Error, report_entry.errors.join(', ') unless report_entry.valid?

        form = csrf_form.merge(report_entry_form(report_entry))
        response = auth_http.post("#{domain}/report/", form:)

        test_report_response_for_error(response)
      end

      def delete_reported_entry(id)
        response = auth_http.get("#{domain}/report/delete/#{id}/")
        raise Error, 'Something went wrong' if response.code != 302
      end

      def compensation(report_date)
        year = report_date.year
        month = report_date.month

        response = auth_http.post("#{domain}/dashboard/block/user_salary_block/", form: { year:, month: })

        Models::Compensation.from_html(response.body.to_s, report_date)
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

        auth_http.post("#{uri}/update/", form:)
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

      def report_entry_form(entry)
        {
          project_id: entry.project.id,
          report_date: entry.task.date.strftime('%Y-%m-%d'),
          activity: entry.activity.id,
          status: entry.task.status.to_i,
          start_report_hours: entry.task.starts_at.hour,
          start_report_minutes: entry.task.starts_at.min,
          end_report_hours: entry.task.ends_at.hour,
          end_report_minutes: entry.task.ends_at.min,
          overtime: entry.overtime ? 2 : 1,
          task_name: entry.task.name,
          task_desc: entry.task.description
        }
      end

      def test_report_response_for_error(response)
        errlist = Nokogiri::HTML.parse(response.body.to_s).xpath('//*[contains(@class, "errorlist")]')
        return nil if errlist.empty?

        raise Error, errlist.xpath('.//li').map(&:text).join("\n")
      end

      def auth_http
        raise NotAuthorizedError, 'You must login first' if auth_cookies.empty?

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
    # rubocop:enable Metrics/ClassLength
  end
end
