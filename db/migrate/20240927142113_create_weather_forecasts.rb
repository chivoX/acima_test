class CreateWeatherForecasts < ActiveRecord::Migration[7.2]
  def change
    create_table :weather_forecasts do |t|
      t.string :search_keyword
      t.jsonb :response
      t.integer :ttl

      t.timestamps
    end
  end
end
