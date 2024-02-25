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

            expect(entries).to all(be_a_valid_reported_entry)
          end
        end
      end

      context 'when user asks for entries from future' do
        it 'returns an empty list' do
          VCR.use_cassette('website/reported_entries_future') do
            cookies = website.login(username, password)
            website.auth(cookies)
            entries = website.reported_entries(year: 2025, month: 1)

            expect(entries).to be_empty
          end
        end
      end

      context 'when user asks for entries too far away past' do
        it 'returns an empty list' do
          VCR.use_cassette('website/reported_entries_past') do
            cookies = website.login(username, password)
            website.auth(cookies)
            entries = website.reported_entries(year: 2000, month: 1)

            expect(entries).to be_empty
          end
        end
      end
    end
  end

  describe '.holidays_this_year' do
    context 'when the user is authorized' do
      let(:expected_holidays) do
        [
          VKPM::Entities::Holiday.new(name: 'Easter Monday', date: Date.new(2024, 5, 6)),
          VKPM::Entities::Holiday.new(name: 'Christmas Day', date: Date.new(2024, 12, 25))
        ]
      end

      it 'returns a list of holidays for the current year' do
        VCR.use_cassette('website/holidays_this_year') do
          cookies = website.login(username, password)
          website.auth(cookies)
          holidays = website.holidays_this_year

          expect(holidays).to all(be_a(VKPM::Entities::Holiday))
          expect(holidays).to include(*expected_holidays)
        end
      end
    end
  end

  describe '.breaks' do
    context 'when the user is authorized' do
      context 'when user has some breaks' do
        it 'returns a list of breaks' do
          VCR.use_cassette('website/breaks') do
            cookies = website.login(username, password)
            website.auth(cookies)
            breaks = website.breaks(year: 2020)

            expect(breaks).to all(be_a_valid_break)
          end
        end
      end
    end
  end

  describe '.available_projects' do
    context 'when the user is authorized' do
      context 'when user has some projects' do
        it 'returns a list of projects' do
          VCR.use_cassette('website/available_projects') do
            cookies = website.login(username, password)
            website.auth(cookies)
            projects = website.available_projects

            expect(projects).to have_attributes(size: be > 0)
            expect(projects).to all(be_a_valid_project)
          end
        end
      end
    end
  end

  describe '.available_activities' do
    context 'when the user is authorized' do
      let(:expected_activities) do
        [
          VKPM::Entities::Activity.new(id: '0', name: 'Estimate'),
          VKPM::Entities::Activity.new(id: '1', name: 'Development'),
          VKPM::Entities::Activity.new(id: '2', name: 'Testing'),
          VKPM::Entities::Activity.new(id: '3', name: 'Bugfixing'),
          VKPM::Entities::Activity.new(id: '4', name: 'Management'),
          VKPM::Entities::Activity.new(id: '5', name: 'Analysis')
        ]
      end

      it 'returns a list of activities' do
        VCR.use_cassette('website/available_activities') do
          cookies = website.login(username, password)
          website.auth(cookies)
          activities = website.available_activities

          expect(activities).to eq(expected_activities)
        end
      end
    end
  end

  describe '.report' do
    context 'when the user is authorized' do
      let(:project) { VKPM::Entities::Project.new(id: '591', name: 'Catapult') }
      let(:activity) { VKPM::Entities::Activity.new(id: '1', name: 'Development') }
      let(:task) do
        VKPM::Entities::Task.new(
          name: 'Catapult',
          description: 'Catapult',
          status: 100,
          date: Date.new(2024, 2, 23),
          starts_at: Time.new(2024, 2, 23, 9, 0, 0),
          ends_at: Time.new(2024, 2, 23, 13, 0, 0)
        )
      end
      let(:report_entry) { VKPM::Entities::ReportEntry.new(project:, activity:, task:) }

      context 'when the report is successful' do
        it 'returns a success message' do
          VCR.use_cassette('website/report_successfully') do
            cookies = website.login(username, password)
            website.auth(cookies)

            expect { website.report(report_entry) }.not_to raise_error
          end
        end
      end

      context 'when there is an overlap with another entry' do
        it 'raises an error' do
          VCR.use_cassette('website/report_overlap') do
            cookies = website.login(username, password)
            website.auth(cookies)

            expect { website.report(report_entry) }.to raise_error(VKPM::Error)
          end
        end
      end
    end
  end
end
