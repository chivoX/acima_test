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

      it 'creates a new weather forecast' do
        expect(subject).to receive(:create_weather_forecast)

        subject.call
      end

      it 'returns a successful response' do
        allow(subject).to receive(:create_weather_forecast).and_return(true)

        response = subject.call

        expect(response.status).to be true
        expect(response.result).to eq(true)
      end
    end

    context 'when there is no cached forecast' do
      before do
        allow(::WeatherForecast).to receive(:find_by_hashed_query_params).with(hashed_params).and_return(nil)
      end

      it 'creates a new weather forecast' do
        expect(subject).to receive(:create_weather_forecast).and_return(true)

        subject.call
      end

      it 'returns a successful response' do
        allow(subject).to receive(:create_weather_forecast).and_return(true)

        response = subject.call

        expect(response.status).to be true
        expect(response.result).to eq(true)
      end
    end

    # context 'when the weather service returns nil' do
    #   before do
    #     allow(WeatherForecast).to receive(:find_by_hashed_query_params).with(hashed_params).and_return(nil)
    #     allow(subject).to receive(:create_weather_forecast).and_return(NilWeatherForecast.new(hashed_params))
    #   end

    #   it 'returns a NilWeatherForecast' do
    #     result = subject.call
    #     expect(result.success?).to be true
    #     expect(result.data).to be_a(NilWeatherForecast)
    #   end
    # end
  end
end
