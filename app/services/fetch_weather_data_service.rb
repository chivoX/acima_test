class FetchWeatherDataService < ApplicationService
  def initialize(city, state)
    @city = city
    @state = state
  end

  def call
    return cached_forecast unless check_ttl
    bust_cache if cached_forecast
    create_weather_forecast
  end

  private

  def cached_forecast
    @cached_forecast ||= WeatherForecast.find_by_hashed_query_params(hashed_query_params)
  end

  def hashed_query_params
    Digest::MD5.hexdigest(@city+@state)
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
    CreateWeatherForecastService.call(@city, @state) || NilWeatherForecast.new(@city, @state)
  end
end
