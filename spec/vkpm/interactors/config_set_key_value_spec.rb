# frozen_string_literal: true

require 'rspec'

RSpec.describe VKPM::Interactors::ConfigSetKeyValue do
  let(:config) { instance_double(VKPM::Adapters::Config) }
  let(:config_key) { 'key' }
  let(:config_value) { 'value' }
  let(:options) { { config:, config_key:, config_value: } }

  describe '.call' do
    context 'when it has all data' do
      let(:result) { described_class.call(**options) }

      it 'sets the value' do
        allow(config).to receive(:set).with(config_key, config_value)
        expect { result }.not_to raise_error
      end
    end

    context 'when there are missing data pieces' do
      let(:missing_config) { options.except(:config) }
      let(:missing_config_key) { options.except(:config_key) }
      let(:missing_config_value) { options.except(:config_value) }

      it 'raises an error when config is missing' do
        expect { described_class.call(**missing_config) }.to raise_error(VKPM::Error, '`config` is not set')
      end

      it 'raises an error when config_key is missing' do
        expect { described_class.call(**missing_config_key) }.to raise_error(VKPM::Error, '`config_key` is not set')
      end

      it 'raises an error when config_value is missing' do
        expect { described_class.call(**missing_config_value) }.to raise_error(VKPM::Error, '`config_value` is not set')
      end
    end
  end
end
