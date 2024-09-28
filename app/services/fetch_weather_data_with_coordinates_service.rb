class FetchWeatherDataWithCoordinatesService < ApplicationService
  def initialize(lat, lon)
    @lat = lat
    @lon = lon
  end

  def call
    return cached_forecast unless check_ttl
    bust_cache if cached_forecast
    create_weather_forecast
  end

  private

  def cached_forecast
    @cached_forecast ||= WeatherForecast.find_by_hashed_coordinates(hashed_coordinates)
  end

  def hashed_coordinates
    Digest::MD5.hexdigest(@lat+@lon)
  end

  # cache will be busted if the cached forecast is expired
  def bust_cache
    cached_forecast.destroy
  end

  # will check ttl if there is a cached_forecast
  def check_ttl
    return true unless cached_forecast
    time_diff = Time.now.to_i - cached_forecast.created_at.to_i
    time_diff > cached_forecast.ttl
  end

  def create_weather_forecast
    CreateWeatherForecastWithCoordinatesService.call(@lat, @lon) || NilWeatherForecast.new(hashed_coordinates)
  end
end
