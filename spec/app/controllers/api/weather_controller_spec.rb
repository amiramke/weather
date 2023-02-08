require 'rails_helper'

RSpec.describe Api::WeatherController, type: :controller do
  describe '#create' do
    let(:location) { instance_double(Location, coordinates: [1, 2], postal_code: '12345') }
    let(:adapter) { instance_double(OpenMeteo, url: 'http://example.com') }
    let(:api) { instance_double(WeatherApi, results: { temperature: 72 }) }

    before do
      allow(Location).to receive(:new).and_return(location)
      allow(OpenMeteo).to receive(:new).and_return(adapter)
      allow(WeatherApi).to receive(:new).and_return(api)
    end

    context 'when address is not provided' do
      it 'returns error' do
        post :create, params: { address: '' }
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['error']).to eq('Address cannot be blank.')
      end
    end

    context 'when location is not found' do
      before do
        allow(location).to receive(:coordinates).and_return(nil)
      end

      it 'returns error' do
        post :create, params: { address: '123 Main St' }
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['error']).to eq('Could not find location.')
      end
    end

    context 'when API request fails' do
      before do
        allow(WeatherApi).to receive(:new).and_raise('API error')
      end

      it 'returns error' do
        post :create, params: { address: '123 Main St' }
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['error']).to eq('API error')
      end
    end

    context 'when API request succeeds' do
      it 'returns weather data' do
        post :create, params: { address: '123 Main St' }
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq('temperature' => 72)
      end
    end
  end
end
