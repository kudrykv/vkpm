# frozen_string_literal: true

require 'rspec'

RSpec.describe 'VKPM::Interactors::ConfigInitialize' do
  describe '#call' do
    let(:result) { VKPM::Interactors::ConfigInitialize.call }

    it 'sets the config to the context' do
      expect(result.config).to be_a(VKPM::Adapters::Config)
    end
  end
end
