class HomeController < ApplicationController
  def index
    if params[:latitude]
      @weather_forecast_result = FetchWeatherDataService.call(:create_with_coordinates, params[:latitude], params[:longitude])
      respond_to do |format|
        format.json { render json: render_to_string(partial: "weather_forecasts/weather_forecast", locals: { weather_forecast: @weather_forecast_result.result }, formats: [ :html ]) }
      end
    end
  end
end
