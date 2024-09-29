# frozen_string_literal: true

class OpenWeatherClient < ApplicationService
  def initialize(url)
    @url = url
  end

  def call
    begin
      response = Excon.get("#{@url}&appid=#{api_key}")
      result = JSON.parse(response.body)

      ServiceResult.new(true, result, nil)

    rescue Excon::Error
      ServiceResult.new(false, nil, Excon::Error)
    end
  end

  private

  def api_key
    ENV["OPEN_WEATHER_API_KEY"]
  end
end
