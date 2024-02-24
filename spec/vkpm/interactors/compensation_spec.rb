# frozen_string_literal: true

RSpec.describe 'VKPM::Interactors::Compensation' do
  let(:website) { instance_double(VKPM::Adapters::Website) }
  let(:report_date) { Date.parse('2024-02-24') }
  let(:options) { { website:, report_date: } }
  let(:compensation) { instance_double(VKPM::Entities::Compensation) }

  before do
    allow(website).to receive(:compensation).with(report_date).and_return(compensation)
  end

  context 'when ins are present' do
    let(:result) { VKPM::Interactors::Compensation.call(**options) }

    it 'sets the compensation' do
      expect { result }.not_to raise_error
      expect(result.compensation).to eq(compensation)
    end
  end

  context 'when some data is missing' do
    it 'raises an error when report_date is missing' do
      expect { VKPM::Interactors::Compensation.call(website:) }.to raise_error(VKPM::Error, '`report_date` is not set')
    end

    it 'raises an error when website is missing' do
      expect { VKPM::Interactors::Compensation.call(report_date:) }.to raise_error(VKPM::Error, '`website` is not set')
    end
  end
end
