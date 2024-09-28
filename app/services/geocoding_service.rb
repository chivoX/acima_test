# frozen_string_literal: true

class GeocodingService < ApplicationService
  def initialize(city, state)
    @city = city
    @state = state
  end

  def call
    begin
      response = Excon.get("http://api.openweathermap.org/geo/1.0/direct?q=#{@city},#{@state},US&limit=1&appid=#{api_key}")
    rescue Excon::Error
      return ServiceResult.new(false, nil, Excon::Error)
    end
    parsed_data = JSON.parse(response.body)

    result = { latitude: parsed_data[0]["lat"], longitude: parsed_data[0]["lon"] }

    ServiceResult.new(true, result, nil)
  end

  private

  def api_key
    ENV["OPEN_WEATHER_API_KEY"]
  end
end
