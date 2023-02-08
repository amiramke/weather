require 'rails_helper'

RSpec.describe WeatherApi, type: :model do
  let(:url) { 'http://example.com' }
  let(:adapter) { instance_double(OpenMeteo) }
  let(:weather_api) { described_class.new(url, adapter) }
  let(:postal_code) { '12345' }

  describe '#fetch_data' do
    it 'fetches data from API' do
      allow(Net::HTTP).to receive(:get).and_return('{ "temp": 72 }')
      result = weather_api.fetch_data
      expect(result).to eq('{ "temp": 72 }')
    end
  end

  describe '#results' do
    it 'calls adapter output with correct parameters' do
      expect(adapter).to receive(:output).with(weather_api, postal_code)
      weather_api.results(postal_code)
    end
  end
end
