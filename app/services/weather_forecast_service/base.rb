module WeatherForecastService
  class Base < ApplicationService
    def call
      raise "Called abstract method: call"
    end

    private

    def fetch_weather_data(latitude, longitude)
      @weather_data_results = WeatherDataService.call(latitude, longitude)
    end

    def hashed_query_params(*args)
      @hashed_query_params = Digest::MD5.hexdigest(args[0].to_s+args[1].to_s)
    end

    def create_weather_forecast
      WeatherForecast.create(
        hashed_query_params: @hashed_query_params,
        response: @weather_data_results.result,
        ttl: ENV["TTL"]
      )
    end
  end
end
