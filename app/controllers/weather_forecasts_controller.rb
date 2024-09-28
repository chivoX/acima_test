class WeatherForecastsController < ApplicationController
  def index
    @weather_forecast = FetchWeatherDataService.call(params[:query])
    respond_to do |format|
      format.json { render json: render_to_string(partial: "weather_forecasts/weather_forecast", locals: { weather_forecast: @weather_forecast }, formats: [ :html ]) }
    end
  end
end
