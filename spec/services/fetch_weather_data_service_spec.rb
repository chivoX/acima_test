require 'rails_helper'

RSpec.describe FetchWeatherDataService do
  let(:service_name) { :create }
  let(:city) { "New York" }
  let(:state) { "NY" }
  let(:hashed_params) { Digest::MD5.hexdigest("#{city}#{state}") }
  let(:cached_forecast) { instance_double(::WeatherForecast, created_at: Time.now, ttl: 3600, destroy: true) }

  describe '#call' do
    subject { described_class.new(service_name, city, state) }


    context 'when there is a valid cached forecast' do
      before do
        allow(::WeatherForecast).to receive(:find_by_hashed_query_params).with(hashed_params).and_return(cached_forecast)
      end

      it 'returns the cached forecast' do
        response = subject.call

        expect(response.status).to be true
        expect(response.result).to eq(cached_forecast)
      end

      it 'does not create a new forecast' do
        expect(subject).not_to receive(:create_weather_forecast)
        subject.call
      end
    end

    context 'when cached forecast is expired' do
      before do
        allow(::WeatherForecast).to receive(:find_by_hashed_query_params).with(hashed_params).and_return(cached_forecast)
        allow(cached_forecast).to receive(:created_at).and_return(Time.now - 3700) # Expired
      end

      it 'busts the cache' do
        expect(cached_forecast).to receive(:destroy)

        subject.call
      end

      context "when weather_forecast_response succeeds" do
        let(:result) { double }
        let(:weather_forecast_response) do
          double(status: true, result: result, errors: nil)
        end
        it 'creates a new weather forecast' do
          expect(subject).to receive(:create_weather_forecast).and_return(weather_forecast_response)

          subject.call
        end

        it 'returns a successful response' do
          allow(subject).to receive(:create_weather_forecast).and_return(weather_forecast_response)

          response = subject.call

          expect(response.status).to be true
          expect(response.result).to eq(result)
        end
      end

      context "when weather_forecast_response fails" do
        let(:errors) { double(message: "there is an error") }
        let(:weather_forecast_response) do
          double(status: false, result: nil, errors: errors)
        end

        it 'returns a failure response' do
          allow(subject).to receive(:create_weather_forecast).and_return(weather_forecast_response)

          response = subject.call

          expect(response.status).to be false
          expect(response.errors).to eq(errors)
        end
      end
    end

    context 'when there is no cached forecast' do
      let(:result) { double }
      let(:weather_forecast_response) do
        double(status: true, result: result, errors: nil)
      end

      before do
        allow(::WeatherForecast).to receive(:find_by_hashed_query_params).with(hashed_params).and_return(nil)
      end

      it 'creates a new weather forecast' do
        expect(subject).to receive(:create_weather_forecast).and_return(weather_forecast_response)

        subject.call
      end

      it 'returns a successful response' do
        allow(subject).to receive(:create_weather_forecast).and_return(weather_forecast_response)

        response = subject.call

        expect(response.status).to be true
        expect(response.result).to eq(result)
      end
    end
  end
end
