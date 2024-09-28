class CreateWeatherForecastWithCoordinatesService < ApplicationService
  def initialize(lat, lon)
    @lat = lat
    @lon = lon
  end

  def call
    fetch_weather_data
    return unless @weather_data
    create_weather_forecast
  end

  private

  def fetch_weather_data
    @weather_data = WeatherDataService.call(@lat, @lon)
  end

  def create_weather_forecast
    WeatherForecast.create(
      hashed_query_params: Digest::MD5.hexdigest(@lat+@lon),
      response: @weather_data,
      ttl: ENV["TTL"]
    )
  end
end
