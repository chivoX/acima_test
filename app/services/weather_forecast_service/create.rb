# frozen_string_literal: true

module WeatherForecastService
  class Create < WeatherForecastService::Base
    def initialize(city, state)
      @city = city
      @state = state
    end

    def call
      geolocation_query
      return ServiceResult.new(false, nil, @geocoding_results.errors) unless @geocoding_results.status
      fetch_weather_data(@geocoding_results.result[:latitude], @geocoding_results.result[:longitude])
      return ServiceResult.new(false, nil, "no geocoding data") unless @weather_data_results.status
      hashed_query_params(@city, @state)
      ServiceResult.new(true, create_weather_forecast, nil)
    end

    private

    def geolocation_query
      @geocoding_results = GeocodingService.call(@city, @state)
    end
  end
end
