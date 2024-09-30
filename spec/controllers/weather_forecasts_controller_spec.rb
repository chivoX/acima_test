# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeatherForecastsController, type: :controller do
  describe "GET #index" do
    let(:city) { 'San Francisco' }
    let(:state) { 'CA' }
    let(:weather_forecast) { double('weather_forecast', result: 'sample result') }

    before do
      allow(FetchWeatherDataService).to receive(:call).with(:create, city, state).and_return(weather_forecast)
    end

    context "when weather forecast have results" do
      it "calls the FetchWeatherDataService with the correct parameters" do
        get :index, params: { city: city, state: state }, format: :json
        
        expect(FetchWeatherDataService).to have_received(:call).with(:create, city, state)
      end
  
      it "renders the weather forecast as json" do
        allow(controller).to receive(:render_to_string).with(
          partial: "weather_forecasts/weather_forecast",
          locals: { weather_forecast: weather_forecast.result },
          formats: [:html]
        ).and_return('mocked partial')
  
        get :index, params: { city: city, state: state }, format: :json
  
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response.body).to eq('mocked partial')
      end
    end

    context "when weather forecast does not have results" do
    end
  end
end