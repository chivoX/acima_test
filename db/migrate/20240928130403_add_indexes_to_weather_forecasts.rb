class AddIndexesToWeatherForecasts < ActiveRecord::Migration[7.2]
  def change
    add_index :weather_forecasts, :search_keyword
    add_index :weather_forecasts, :hashed_coordinates
  end
end
