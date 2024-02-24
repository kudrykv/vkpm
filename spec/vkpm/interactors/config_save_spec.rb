# frozen_string_literal: true

require 'rspec'

RSpec.describe 'VKPM::Interactors::ConfigSave' do
  let(:config) { instance_double(VKPM::Adapters::Config, write: true) }

  describe '#call' do
    context 'when config is there' do
      it 'calls the write' do
        VKPM::Interactors::ConfigSave.call(config:)
        expect(config).to have_received(:write)
      end
    end

    context 'when config is not there' do
      it 'raises an error' do
        expect { VKPM::Interactors::ConfigSave.call }.to raise_error(VKPM::Error, '`config` is not set')
      end
    end
  end
end
