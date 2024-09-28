# frozen_string_literal: true

class CreateWeatherForecastService < ApplicationService
  def initialize(city, state)
    @city = city
    @state = state
  end

  def call
    geolocation_query
    return ServiceResult.new(false, nil, "bad coordinates") unless @geocoding_results.status
    fetch_weather_data
    return ServiceResult.new(false, nil, "no geocoding data") unless @weather_data_results.status
    create_weather_forecast
  end

  private

  def geolocation_query
    @geocoding_results = GeocodingService.call(@city, @state)
  end

  def fetch_weather_data
    @weather_data_results = WeatherDataService.call(@geocoding_results.result[:lat], @geocoding_results.result[:lon])
  end

  def create_weather_forecast
    WeatherForecast.create(
      hashed_query_params: Digest::MD5.hexdigest(@city+@state),
      response: @weather_data_results.result,
      ttl: ENV["TTL"]
    )
  end
end
