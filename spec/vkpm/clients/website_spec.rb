# frozen_string_literal: true

RSpec.describe VKPM::Clients::Website do
  let(:uri) { ENV.fetch('VKPM_URI', STUB_URI) }
  let(:username) { ENV.fetch('VKPM_USERNAME', STUB_USERNAME) }
  let(:password) { ENV.fetch('VKPM_PASSWORD', STUB_PASSWORD) }

  let(:website) { described_class.new(domain: uri) }

  describe '.login' do
    context 'when credentials are correct' do
      it 'returns auth cookies' do
        VCR.use_cassette('website/login_successfully') do
          cookies = website.login(username, password)

          expect(cookies).to be_an(Array)
          expect(cookies).to all(be_a(VKPM::Entities::Cookie))
          expect(cookies.map(&:name)).to include('csrftoken', 'sessionid')
          expect(cookies.map(&:value)).to all(be_a(String))
        end
      end
    end

    context 'when credentials are incorrect' do
      it 'raises an error' do
        VCR.use_cassette('website/login_unsuccessfully') do
          expect { website.login('wrong', 'wrong') }.to raise_error(VKPM::BadCredentialsError)
        end
      end
    end
  end

  describe '.reported_entries' do
    context 'when the user is authorized' do
      context 'when user has some entries' do
        it 'returns a list of entries' do
          VCR.use_cassette('website/reported_entries') do
            cookies = website.login(username, password)
            website.auth(cookies)
            entries = website.reported_entries(year: 2020, month: 1)

            expect(entries).to be_an(Array)
            expect(entries).to all(be_a(VKPM::Entities::ReportEntry))
          end
        end
      end
    end
  end
end
