class HomeController < ApplicationController
  def index
    if params[:lat]
      @weather_forecast = FetchWeatherDataWithCoordinatesService.call(params[:lat], params[:lon])
      respond_to do |format|
        format.json { render json: render_to_string(partial: "weather_forecasts/weather_forecast", formats: [ :html ]) }
      end
    end
  end
end
