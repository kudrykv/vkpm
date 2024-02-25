# frozen_string_literal: true

RSpec.describe VKPM::Adapters::Config do
  let(:client) { double('client') }
  let(:config) { described_class.new(client:) }

  before do
    allow(client).to receive(:append_path).with(VKPM::Adapters::Config::ABSOLUTE_DIR)
    allow(client).to receive(:filename=).with(VKPM::Adapters::Config::FILE)
    allow(client).to receive(:exist?).and_return(true)
    allow(client).to receive(:read)
  end

  describe '.initialize' do
    it 'initializes the object and creates the config when one is missing' do
      allow(client).to receive(:exist?).and_return(false)
      allow(client).to receive(:write).with(force: true, create: true)

      expect { config }.not_to raise_error

      expect(client).to have_received(:append_path).with(VKPM::Adapters::Config::ABSOLUTE_DIR)
      expect(client).to have_received(:filename=).with(VKPM::Adapters::Config::FILE)
      expect(client).to have_received(:exist?)
      expect(client).to have_received(:write).with(force: true, create: true)
      expect(client).to have_received(:read)
    end

    it 'initializes the object and reads the config when one is present' do
      expect { config }.not_to raise_error

      expect(client).to have_received(:append_path).with(VKPM::Adapters::Config::ABSOLUTE_DIR)
      expect(client).to have_received(:filename=).with(VKPM::Adapters::Config::FILE)
      expect(client).to have_received(:exist?)
      expect(client).to have_received(:read)
    end
  end

  describe '.set' do
    context 'when the key is within a known list' do
      let(:key) { 'backend.domain' }
      let(:value) { 'https://example.com' }

      before do
        allow(client).to receive(:set).with(key, value:)
        allow(client).to receive(:write)
      end

      it 'sets the key with a value' do
        config.set(key, value)

        expect(client).to have_received(:set).with(key, value:)
      end
    end

    context 'when the key is not within a known list' do
      let(:key) { 'unknown.key' }
      let(:value) { 'https://example.com' }

      it 'raises an error' do
        expect { config.set(key, value) }.to raise_error(VKPM::Error, "Invalid key: #{key}")
      end
    end
  end

  describe '.unset' do
    context 'when the key is within a known list' do
      let(:key) { 'backend.domain' }

      before do
        allow(client).to receive(:delete).with(key)
        allow(client).to receive(:write)
      end

      it 'deletes the key' do
        config.unset(key)

        expect(client).to have_received(:delete).with(key)
      end
    end

    context 'when the key is not within a known list' do
      let(:key) { 'unknown.key' }

      it 'raises an error' do
        expect { config.unset(key) }.to raise_error(VKPM::Error, "Invalid key: #{key}")
      end
    end
  end

  describe '.backend_domain' do
    context 'when the domain is set' do
      let(:key) { 'backend.domain' }
      let(:domain) { 'https://example.com' }

      before do
        allow(client).to receive(:fetch).with(key).and_return(domain)
      end

      it 'returns the domain' do
        expect(config.backend_domain).to eq(domain)

        expect(client).to have_received(:fetch).with(key)
      end
    end

    context 'when the domain is not set' do
      let(:key) { 'backend.domain' }

      before do
        allow(client).to receive(:fetch).with(key).and_return(nil)
      end

      it 'returns nil' do
        expect(config.backend_domain).to be_nil

        expect(client).to have_received(:fetch).with(key)
      end
    end
  end

  describe '.auth_cookies' do
    let(:key) { 'auth.cookies' }

    context 'when the cookies are set' do
      let(:serialized_cookies) { [{ 'name' => 'k1', 'value' => 'v1' }, { 'name' => 'k2', 'value' => 'v2' }] }
      let(:cookies) { [VKPM::Entities::Cookie.new('k1', 'v1'), VKPM::Entities::Cookie.new('k2', 'v2')] }

      before do
        allow(client).to receive(:fetch).with(key).and_return(serialized_cookies)
      end

      it 'returns the cookies' do
        expect(config.auth_cookies).to eq(cookies)

        expect(client).to have_received(:fetch).with(key)
      end
    end

    context 'when the cookies are not set' do
      before do
        allow(client).to receive(:fetch).with(key).and_return(nil)
      end

      it 'returns nil' do
        expect(config.auth_cookies).to be_nil

        expect(client).to have_received(:fetch).with(key)
      end
    end
  end

  describe '.default_project' do
    let(:key) { 'default.project' }

    context 'when the project is set' do
      let(:project) { { 'id' => 1, 'name' => 'Project' } }
      let(:expected_project) { VKPM::Entities::Project.new(id: 1, name: 'Project') }

      before do
        allow(client).to receive(:fetch).with(key).and_return(project)
      end

      it 'returns the project' do
        expect(config.default_project).to eq(expected_project)

        expect(client).to have_received(:fetch).with(key)
      end
    end

    context 'when the project is not set' do
      before do
        allow(client).to receive(:fetch).with(key).and_return(nil)
      end

      it 'returns nil' do
        expect(config.default_project).to be_nil

        expect(client).to have_received(:fetch).with(key)
      end
    end
  end

  describe '.default_activity' do
    let(:key) { 'default.activity' }

    context 'when the activity is set' do
      let(:activity) { { 'id' => 1, 'name' => 'Activity' } }
      let(:expected_activity) { VKPM::Entities::Activity.new(id: 1, name: 'Activity') }

      before do
        allow(client).to receive(:fetch).with(key).and_return(activity)
      end

      it 'returns the activity' do
        expect(config.default_activity).to eq(expected_activity)

        expect(client).to have_received(:fetch).with(key)
      end
    end

    context 'when the activity is not set' do
      before do
        allow(client).to receive(:fetch).with(key).and_return(nil)
      end

      it 'returns nil' do
        expect(config.default_activity).to be_nil

        expect(client).to have_received(:fetch).with(key)
      end
    end
  end

  describe '.to_h' do
    let(:pairs) do
      [
        { name: 'backend.domain', value: 'https://example.com' },
        { name: 'auth.cookies', value: [{ 'name' => 'k1', 'value' => 'v1' }] },
        { name: 'default.project.name', value: 'Project' },
        { name: 'default.activity.name', value: 'Activity' }
      ]
    end

    let(:expected_hash) do
      {
        'backend.domain' => 'https://example.com',
        'auth.cookies' => '********',
        'default.project.name' => 'Project',
        'default.activity.name' => 'Activity'
      }
    end

    before do
      pairs.each { |pair| allow(client).to receive(:fetch).with(pair[:name]).and_return(pair[:value]) }
    end

    it 'returns a hash with the keys and values' do
      expect(config.to_h).to eq(expected_hash)

      pairs.each { |pair| expect(client).to have_received(:fetch).with(pair[:name]) }
    end
  end
end
