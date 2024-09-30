# frozen_string_literal: true

class GeocodingService < ApplicationService
  def initialize(city, state)
    @city = city
    @state = state
    @url = URI::Parser.new.escape("http://api.openweathermap.org/geo/1.0/direct?q=#{@city},#{@state},US&limit=1")
  end

  def call
    response = OpenWeatherClient.call(@url)
    return response unless response.status

    result = { latitude: response.result[0]["lat"], longitude: response.result[0]["lon"] }
    ServiceResult.new(true, result, nil)
  end
end
