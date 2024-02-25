# frozen_string_literal: true

uri = ENV.fetch('VKPM_URI', nil)
domain = URI.parse(uri).host if uri

STUB_URI = 'https://vkpm.stub.local'
STUB_DOMAIN = 'vkpm.stub.local'
STUB_USERNAME = 'stub-user'
STUB_PASSWORD = 'stub-password'
STUB_CSRF_TOKEN = 'stub-csrf-token'
STUB_SESSION_ID = 'stub-session-id'

request_body_replacers = [
  {
    pattern: /csrfmiddlewaretoken=[^&]+&?/,
    replacement: "csrfmiddlewaretoken=#{STUB_CSRF_TOKEN}&"
  },
  {
    pattern: /username=[^&]+&?/,
    replacement: "username=#{STUB_USERNAME}&"
  },
  {
    pattern: /password=[^&]+&?/,
    replacement: "password=#{STUB_PASSWORD}&"
  }
].compact

response_body_replacers = [
  {
    pattern: /<input[^>]+name='csrfmiddlewaretoken'[^>]+>/,
    replacement: "<input type=\"hidden\" name=\"csrfmiddlewaretoken\" value=\"#{STUB_CSRF_TOKEN}\">"
  }
].compact

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!

  config.filter_sensitive_data(STUB_URI) { uri }

  config.before_record do |interaction|
    interaction.request.uri.gsub!(domain, STUB_DOMAIN) if domain
    interaction.request.headers['Host']&.each { |header| header.gsub!(domain, STUB_DOMAIN) } if domain
    interaction.request.headers['Referer']&.each { |header| header.gsub!(domain, STUB_DOMAIN) } if domain
    interaction.request.headers['Cookie']&.each do |header|
      header.gsub!(/csrftoken=[^;]+;?/, "csrftoken=#{STUB_CSRF_TOKEN};")
      header.gsub!(/sessionid=[^;]+;?/, "sessionid=#{STUB_SESSION_ID};")
    end

    interaction.request.body.gsub!(domain, STUB_DOMAIN) if domain
    request_body_replacers.each do |replacer|
      interaction.request.body.gsub!(replacer[:pattern], replacer[:replacement])
    end

    interaction.response.headers['Set-Cookie']&.each do |header|
      header.gsub!(/csrftoken=[^;]+;/, "csrftoken=#{STUB_CSRF_TOKEN};")
      header.gsub!(/sessionid=[^;]+;/, "sessionid=#{STUB_SESSION_ID};")
    end
    interaction.response.headers['Location']&.each { |header| header.gsub!(domain, STUB_DOMAIN) } if domain

    response_body_replacers.each do |replacer|
      interaction.response.body.gsub!(replacer[:pattern], replacer[:replacement])
    end

    interaction.response.body.gsub!(domain, STUB_DOMAIN) if domain
  end
end
