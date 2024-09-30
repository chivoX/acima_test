require 'rails_helper'

RSpec.describe GeocodingService do
  let(:city) { "New York" }
  let(:state) { "NY" }
  let(:service) { described_class.new(city, state) }
  let(:api_url) { "http://api.openweathermap.org/geo/1.0/direct?q=#{city},#{state},US&limit=1" }

  describe '#call' do
    context 'when the API call is successful' do
      let(:api_response) do
        double(status: true, result: [ { "lat" => 40.7128, "lon" => -74.0060 } ])
      end

      before do
        allow(OpenWeatherClient).to receive(:call).with(service.instance_variable_get(:@url)).and_return(api_response)
      end

      it 'returns the latitude and longitude' do
        result = service.call
        expect(result.status).to be true
        expect(result.result).to eq({ latitude: 40.7128, longitude: -74.0060 })
        expect(result.errors).to be nil
      end
    end

    context 'when the API call is unsuccessful' do
      let(:api_response) { double(status: false, result: nil) }

      before do
        allow(OpenWeatherClient).to receive(:call).with(service.instance_variable_get(:@url)).and_return(api_response)
      end

      it 'returns an unsuccessful ServiceResult' do
        result = service.call
        expect(result.status).to be false
        expect(result.result).to be_nil
      end
    end
  end
end
