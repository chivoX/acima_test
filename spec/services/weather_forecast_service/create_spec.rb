require 'rails_helper'

RSpec.describe WeatherForecastService::Create do
  let(:city) { 'New York' }
  let(:state) { 'NY' }

  describe '#call' do
    subject { described_class.new(city, state).call }

    context 'success' do
      let(:geocoding_response) do
        double(status: true, result: { latitude: 10, longitude: 10 })
      end

      let(:weather_data_response) do
        double(status: true, result: { status: 'ok' })
      end

      before do
        allow(GeocodingService).to receive(:call).with(city, state).and_return(geocoding_response)
        allow(WeatherDataService).to receive(:call).with(10, 10).and_return(weather_data_response)
      end

      it 'creates a new WeatherForecast object' do
        expect do
          subject
        end.to change(::WeatherForecast, :count).by(1)
      end
    end

    context 'failure' do
      context "with an error on geocoding service" do
        let(:geocoding_response) do
          double(status: false)
        end

        before do
          allow(GeocodingService).to receive(:call).with(city, state).and_return(geocoding_response)
        end

        it 'returns an error message' do
          expect(subject.errors).to eq('location not found')
        end

        it 'does not create a new WeatherForecast object' do
          expect do
            subject
          end.to change(::WeatherForecast, :count).by(0)
        end
      end

      context "with an error on weather_data service" do
        let(:geocoding_response) do
          double(status: true, result: { latitude: 10, longitude: 10 })
        end

        let(:weather_data_response) do
          double(status: false)
        end

        before do
          allow(GeocodingService).to receive(:call).with(city, state).and_return(geocoding_response)
          allow(WeatherDataService).to receive(:call).with(10, 10).and_return(weather_data_response)
        end

        it 'returns an error message' do
          expect(subject.errors).to eq('no geocoding data')
        end

        it 'does not create a new WeatherForecast object' do
          expect do
            subject
          end.to change(::WeatherForecast, :count).by(0)
        end
      end
    end
  end
end
