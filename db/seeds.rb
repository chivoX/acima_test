# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

response = { "dt"=>1727670389, "id"=>4887398, "cod"=>200, "sys"=>{ "id"=>2005153, "type"=>2, "sunset"=>1727652926, "country"=>"US", "sunrise"=>1727610340 }, "base"=>"stations", "main"=>{ "temp"=>70.12, "humidity"=>83, "pressure"=>1015, "temp_max"=>71.06, "temp_min"=>68.14, "sea_level"=>1015, "feels_like"=>70.74, "grnd_level"=>994 }, "name"=>"Chicago", "wind"=>{ "deg"=>18, "gust"=>3, "speed"=>3 }, "coord"=>{ "lat"=>41.8836, "lon"=>-87.6201 }, "clouds"=>{ "all"=>53 }, "weather"=>[ { "id"=>803, "icon"=>"04n", "main"=>"Clouds", "description"=>"broken clouds" } ], "timezone"=>-18000, "visibility"=>10000 }

tll = 3600

hashed_query_params =  "ee157dacd6892df7bef53d05d97fd84f"

WeatherForecast.create!(response: response, ttl: tll, hashed_query_params: hashed_query_params)
