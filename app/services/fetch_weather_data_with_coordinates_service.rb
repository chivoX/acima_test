class FetchWeatherDataWithCoordinatesService < ApplicationService
  def initialize(lat, lon)
    @lat = lat
    @lon = lon
  end

  # cheking first if cache is expired to bust it
  # if not expired cache is used
  # new forecast is created if not on cache
  def call
    return ServiceResult.new(true, cached_forecast, nil) unless check_ttl
    bust_cache if cached_forecast
    ServiceResult.new(true, create_weather_forecast, nil)
  end

  private

  def cached_forecast
    @cached_forecast ||= WeatherForecast.find_by_hashed_query_params(hashed_query_params)
  end

  # hashed lat + lon to be used to see if already exists in the db
  def hashed_query_params
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
    CreateWeatherForecastWithCoordinatesService.call(@lat, @lon) || NilWeatherForecast.new(hashed_query_params)
  end
end
