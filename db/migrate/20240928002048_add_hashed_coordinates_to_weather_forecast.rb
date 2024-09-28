class AddHashedCoordinatesToWeatherForecast < ActiveRecord::Migration[7.2]
  def change
    add_column :weather_forecasts, :hashed_coordinates, :string
  end
end
