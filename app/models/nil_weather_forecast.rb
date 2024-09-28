NilWeatherForecast = Struct.new(:hashed_query_params) do
  def ttl
    0
  end

  def response
    {}
  end
end
