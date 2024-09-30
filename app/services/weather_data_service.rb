# frozen_string_literal: true

class WeatherDataService < ApplicationService
  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
    @url = "https://api.openweathermap.org/data/2.5/weather?lat=#{@latitude}&lon=#{@longitude}&units=imperial"
  end

  def call
    OpenWeatherClient.call(@url)
  end
end
