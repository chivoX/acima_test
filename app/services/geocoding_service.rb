class GeocodingService < ApplicationService
  def initialize(name)
    @name = name
  end

  def call
    begin
      response = Excon.get("http://api.openweathermap.org/geo/1.0/direct?q=#{@name}&limit=5&appid=#{api_key}")
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
