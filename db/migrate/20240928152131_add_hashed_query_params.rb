class AddHashedQueryParams < ActiveRecord::Migration[7.2]
  def change
    add_column :weather_forecasts, :hashed_query_params, :string
    add_index :weather_forecasts, :hashed_query_params

    remove_index :weather_forecasts, :search_keyword
    remove_index :weather_forecasts, :hashed_coordinates
    remove_column :weather_forecasts, :hashed_coordinates
    remove_column :weather_forecasts, :search_keyword
  end
end
