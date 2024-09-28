# frozen_string_literal: true

class WeatherDataService < ApplicationService
  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
  end

  def call
    begin
      response = Excon.get("https://api.openweathermap.org/data/2.5/weather?lat=#{@latitude}&lon=#{@longitude}&appid=#{api_key}")
    rescue Excon::Error
      return ServiceResult.new(false, nil, Excon::Error)
    end

    result = JSON.parse(response.body)

    ServiceResult.new(true, result, nil)
  end

  private

  def api_key
    ENV["OPEN_WEATHER_API_KEY"]
  end
end
