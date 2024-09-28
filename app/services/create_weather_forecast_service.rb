class CreateWeatherForecastService < ApplicationService
  def initialize(city, state)
    @city = city
    @state = state
  end

  def call
    geolocation_query
    return unless @coordinates
    fetch_weather_data
    return unless @weather_data
    create_weather_forecast
  end

  private

  def geolocation_query
    @coordinates = GeocodingService.call(@city, @state)
  end

  def fetch_weather_data
    @weather_data = WeatherDataService.call(@coordinates[:lat], @coordinates[:lon])
  end

  def create_weather_forecast
    WeatherForecast.create(
      hashed_query_params: Digest::MD5.hexdigest(@city+@state),
      response: @weather_data,
      ttl: ENV["TTL"]
    )
  end
end
