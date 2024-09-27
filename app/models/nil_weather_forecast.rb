NilWeatherForecast = Struct.new(:search_keyword) do
  def ttl
    0
  end

  def response
    {}
  end
end
