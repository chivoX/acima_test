class WeatherForecastsController < ApplicationController
  def index
    @weather_forecast_result = FetchWeatherDataService.call(:create, params[:city], params[:state])
    respond_to do |format|
      format.json { render json: {
        status: @weather_forecast_result.status,
        result: results,
        errors: @weather_forecast_result&.errors&.message }
      }.to_json
    end
  end

  private

  def results
    return {} unless @weather_forecast_result.status
    render_to_string(partial: "weather_forecasts/weather_forecast", locals: { weather_forecast: @weather_forecast_result.result }, formats: [ :html ])
  end
end
