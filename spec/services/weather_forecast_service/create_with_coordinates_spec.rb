require 'rails_helper'

RSpec.describe WeatherForecastService::CreateWithCoordinates do
  let(:latitude) { 10 }
  let(:longitude) { 10 }

  describe '#call' do
    subject { described_class.new(latitude, longitude).call }

    context 'success' do
      let(:weather_data_response) do
        double(status: true, result: {status: 'ok'})
      end

      before do
        allow(WeatherDataService).to receive(:call).with(latitude, longitude).and_return(weather_data_response)
      end
      
      it 'creates a new WeatherForecast object' do
        expect do
          subject
        end.to change(::WeatherForecast, :count).by(1)
      end
    end

    context 'failure' do
      context "with an error on weather_data service" do
        let(:geocoding_response) do
          double(status: true, result: { latitude: latitude, longitude: longitude })
        end

        let(:weather_data_response) do
          double(status: false)
        end

        before do
          allow(WeatherDataService).to receive(:call).with(latitude, longitude).and_return(weather_data_response)
        end

        it 'returns an error message' do
          expect(subject.errors).to eq('bad coordinates')
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
