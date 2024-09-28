class GeocodingService < ApplicationService
  def initialize(city, state)
    @city = city
    @state = state
  end

  def call
    begin
      response = Excon.get("http://api.openweathermap.org/geo/1.0/direct?q=#{@city},#{@state},US&limit=1&appid=#{api_key}")
    rescue Excon::Error
      return false
    end
    parsed_data = JSON.parse(response.body)

    { lat: parsed_data[0]["lat"], lon: parsed_data[0]["lon"] }
  end

  private

  def api_key
    ENV["OPEN_WEATHER_API_KEY"]
  end
end
