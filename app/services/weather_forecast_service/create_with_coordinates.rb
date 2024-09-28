# frozen_string_literal: true

module WeatherForecastService
  class CreateWithCoordinates < WeatherForecastService::Base
    def initialize(latitude, longitude)
      @latitude = latitude
      @longitude = longitude
    end

    def call
      fetch_weather_data(@latitude, @longitude)
      return ServiceResult.new(false, nil, "bad coordinates") unless @weather_data_results.status
      hashed_query_params(@latitude, @longitude)
      create_weather_forecast
    end
  end
end
