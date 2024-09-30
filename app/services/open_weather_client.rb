# frozen_string_literal: true

class OpenWeatherClient < ApplicationService
  def initialize(url)
    @url = url
  end

  def call
    handle_errors do
      Excon.get("#{@url}&appid=#{api_key}")
    end
  end

  private

  def handle_errors(&block)
    response = block.call
    raise EmptyResponseError if parse_response(response.body).empty?
    ServiceResult.new(true, parse_response(response.body), nil)
  rescue Excon::Error
    ServiceResult.new(false, nil, Excon::Error)
  rescue EmptyResponseError
    ServiceResult.new(false, nil, EmptyResponseError.new)
  end

  def parse_response(body)
    JSON.parse(body)
  end

  def api_key
    ENV["OPEN_WEATHER_API_KEY"]
  end
end

class EmptyResponseError < StandardError
  def message
    "The city may not exist in this State, try a different State?"
  end
end
