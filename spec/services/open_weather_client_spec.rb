require 'rails_helper'

RSpec.describe OpenWeatherClient do
  let(:url) { "http://api.openweathermap.org/data/2.5/weather?lat=40.7128&lon=-74.0060" }
  let(:client) { described_class.new(url) }
  let(:api_key) { "your_api_key" }

  before do
    allow(ENV).to receive(:[]).with("OPEN_WEATHER_API_KEY").and_return(api_key)
  end

  describe '#call' do
    context 'when the API call is successful' do
      let(:response_body) do
        {
          "dt"=>1727659398,
         "id"=>3689147,
         "cod"=>200,
         "sys"=>{ "id"=>8584, "type"=>1, "sunset"=>1727650241, "country"=>"CO", "sunrise"=>1727606883 },
         "base"=>"stations",
         "main"=>{ "temp"=>296.97, "humidity"=>100, "pressure"=>1011, "temp_max"=>296.97, "temp_min"=>296.97, "sea_level"=>1011, "feels_like"=>298.02, "grnd_level"=>1009 },
         "name"=>"Barranquilla",
         "wind"=>{ "deg"=>0, "speed"=>1.03 },
         "coord"=>{ "lat"=>11.022, "lon"=>-74.8196 },
         "clouds"=>{ "all"=>20 },
         "weather"=>[ { "id"=>801, "icon"=>"02n", "main"=>"Clouds", "description"=>"few clouds" } ],
         "timezone"=>-18000,
         "visibility"=>10000
        }.to_json
      end

      before do
        allow(Excon).to receive(:get).with("#{url}&appid=#{api_key}").and_return(double(body: response_body))
      end

      it 'returns a successful ServiceResult with parsed response' do
        result = client.call
        expect(result.status).to be true
        expect(result.result).to eq(JSON.parse(response_body))
      end
    end

    # context 'when the API call raises Excon::Error' do
    #   before do
    #     allow(Excon).to receive(:get).with("#{url}&appid=#{api_key}").and_raise(Excon::Error)
    #   end

    #   it 'returns an unsuccessful ServiceResult with Excon::Error' do
    #     result = client.call
    #     expect(result.status).to be false
    #     expect(result.result).to be nil
    #     expect(result.errors).to be_a(Excon::Error)
    #   end
    # end

    context 'when the response body is empty' do
      before do
        allow(Excon).to receive(:get).with("#{url}&appid=#{api_key}").and_return(double(body: "[]"))
      end

      it 'raises EmptyResponseError and returns an unsuccessful ServiceResult' do
        result = client.call
        expect(result.status).to be false
        expect(result.errors).to be_a(EmptyResponseError)
      end
    end
  end
end
