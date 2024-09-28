class CreateWeatherForecastWithCoordinatesService < ApplicationService
  def initialize(lat, lon)
    @lat = lat
    @lon = lon
  end

  def call
    fetch_weather_data
    return ServiceResult.new(false, nil, "bad coordinates") unless @weather_data_results.status
    create_weather_forecast
  end

  private

  def fetch_weather_data
    @weather_data_results = WeatherDataService.call(@lat, @lon).results
  end

  def create_weather_forecast
    WeatherForecast.create(
      hashed_query_params: Digest::MD5.hexdigest(@lat+@lon),
      response: @weather_data_results,
      ttl: ENV["TTL"]
    )
  end
end
