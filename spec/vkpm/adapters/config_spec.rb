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
end
