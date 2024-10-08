# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeatherForecastsController, type: :controller do
  describe "GET #index" do
    let(:city) { 'San Francisco' }
    let(:state) { 'CA' }

    before do
      allow(FetchWeatherDataService).to receive(:call).with(:create, city, state).and_return(weather_forecast)
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
        expect(response.body).to eq(expected_response)
      end
    end

    context "when weather forecast does not have results" do
      let(:weather_forecast) { double('weather_forecast', result: nil, status: false, errors: double(message: "there is an error")) }
      let(:expected_response) do
        {
          status: false,
          result: {},
          errors: "there is an error"
        }.to_json
      end

      it "renders a failure response as json" do  
        get :index, params: { city: city, state: state }, format: :json
  
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response.body).to eq(expected_response)
      end
    end
  end
end