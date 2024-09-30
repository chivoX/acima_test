# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET #index" do
    let(:latitude) { "10" }
    let(:longitude) { "10" }

    before do
      allow(FetchWeatherDataService).to receive(:call).with(:create_with_coordinates, latitude, longitude).and_return(weather_forecast)
    end

    context "when weather forecast have results" do
      let(:weather_forecast) { double('weather_forecast', result: 'sample result', status: true, errors: double(message: "")) }
      let(:expected_response) do
        {
          status: true,
          result: "mocked partial",
          errors: ""
        }.to_json
      end

      it "calls the FetchWeatherDataService with the correct parameters" do
        get :index, params: { latitude: latitude, longitude: longitude }, format: :json
        
        expect(FetchWeatherDataService).to have_received(:call).with(:create_with_coordinates, latitude, longitude)
      end
  
      it "renders the weather forecast as json" do
        allow(controller).to receive(:render_to_string).with(
          partial: "weather_forecasts/weather_forecast",
          locals: { weather_forecast: weather_forecast.result },
          formats: [:html]
        ).and_return('mocked partial')
  
        get :index, params: { latitude: latitude, longitude: longitude }, format: :json
  
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response.body).to eq("mocked partial")
      end
    end
  end
end