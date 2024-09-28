# frozen_string_literal: true

class CreateWeatherForecastWithCoordinatesService < ApplicationService
  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
  end

  def call
    fetch_weather_data
    return ServiceResult.new(false, nil, "bad coordinates") unless @weather_data_results.status
    create_weather_forecast
  end

  private

  def fetch_weather_data
    @weather_data_results = WeatherDataService.call(@latitude, @longitude)
  end

  def create_weather_forecast
    WeatherForecast.create(
      hashed_query_params: Digest::MD5.hexdigest(@latitude+@longitude),
      response: @weather_data_results.result,
      ttl: ENV["TTL"]
    )
  end
end
