class WeatherDataService < ApplicationService
  def initialize(lat, lon)
    @lat = lat
    @lon = lon
  end

  def call
    begin
      response = Excon.get("https://api.openweathermap.org/data/2.5/weather?lat=#{@lat}&lon=#{@lon}&appid=#{api_key}")
    rescue Excon::Error
      return false
    end
    JSON.parse(response.body)
  end

  private

  def api_key
    ENV["OPEN_WEATHER_API_KEY"]
  end
end
