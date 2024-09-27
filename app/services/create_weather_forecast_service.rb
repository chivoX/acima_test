class CreateWeatherForecastService < ApplicationService
  def initialize(query)
    @query = query
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
    @coordinates = GeocodingService.call(@query)
  end

  def fetch_weather_data
    @weather_data = WeatherDataService.call(@coordinates[:lat], @coordinates[:lon])
  end

  def create_weather_forecast
    WeatherForecast.create(
      search_keyword: @query,
      response: @weather_data,
      ttl: ENV["TTL"]
    )
  end
end
