require 'rails_helper'

RSpec.describe OpenMeteo, type: :model do
  let(:open_meteo) { described_class.new }
  let(:context) { instance_double(WeatherApi, fetch_data: '{ "current_weather": { "temp": 72 }, "daily": { "time": [1, 2, 3], "temperature_2m_min": [50, 60, 70], "temperature_2m_max": [80, 90, 100] } }') }
  let(:postal_code) { '12345' }

  describe '#url' do
    it 'generates correct URL' do
      expect(open_meteo.url(1, 2)).to eq('https://api.open-meteo.com/v1/forecast?latitude=1&longitude=2&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset&current_weather=true&temperature_unit=fahrenheit&windspeed_unit=mph&precipitation_unit=inch&timezone=auto')
    end
  end

  describe '#output' do
    context 'when postal code is provided' do
      context 'when cache is hit' do
        before do
          allow(Rails.cache).to receive(:fetch).and_return('{ "current_weather": { "temp": 72 }, "daily": { "time": [1, 2, 3], "temperature_2m_min": [50, 60, 70], "temperature_2m_max": [80, 90, 100] } }')
        end

        it 'returns weather data from cache' do
          result = open_meteo.output(context, postal_code)
          expect(result).to eq('temp' => 72, 'weekly_forecast' => { 1 => [50, 80], 2 => [60, 90], 3 => [70, 100] }, 'cache_hit' => 'true')
        end
      end

      context 'when cache is not hit' do
        it 'returns weather data from API' do
          result = open_meteo.output(context, postal_code)
          expect(result).to eq('temp' => 72, 'weekly_forecast' => { 1 => [50, 80], 2 => [60, 90], 3 => [70, 100] }, 'cache_hit' => 'false')
        end
      end
    end

    context 'when postal code is not provided' do
      it 'returns weather data from API' do
        result = open_meteo.output(context, nil)
        expect(result).to eq('temp' => 72, 'weekly_forecast' => { 1 => [50, 80], 2 => [60, 90], 3 => [70, 100] }, 'cache_hit' => 'false')
      end
    end
  end
end
