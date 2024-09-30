require 'rails_helper'

RSpec.describe WeatherDataService do
  let(:latitude) { 40.7128 }
  let(:longitude) { -74.0060 }
  let(:service) { described_class.new(latitude, longitude) }
  let(:api_url) { "https://api.openweathermap.org/data/2.5/weather?lat=#{latitude}&lon=#{longitude}" }

  describe '#call' do
    context 'when the API call is successful' do
      let(:api_response) do
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
        }
      end

      before do
        allow(OpenWeatherClient).to receive(:call).with(api_url).and_return(double(status: true, result: api_response))
      end

      it 'makes a successful API call and returns the weather data' do
        result = service.call
        expect(result.status).to be true
        expect(result.result).to eq(api_response)
      end
    end

    context 'when the API call fails' do
      before do
        allow(OpenWeatherClient).to receive(:call).with(api_url).and_return(double(status: false, result: nil))
      end

      it 'returns an unsuccessful response' do
        result = service.call
        expect(result.status).to be false
        expect(result.result).to be_nil
      end
    end
  end
end
