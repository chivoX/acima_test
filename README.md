# Acima Test

This test for acima required the following challenges to be completed:

## Backend
* Implementing a weather service (I chose OpenWeatherWeatherMap.org's).

* Store responses in a database and use as cache. Valid for 1 hour.

## Frontend

* Allow location service on your browser and use your current location to look up the current weather.

* Display current location weather on first load.

* Bonus: Provide a search for weather by City/State.

## Configuration

You will need to rename .env.sample to .env and setup the database.

1. Run bundle
```
bundle install
```

2. Run Yarn
```
yarn install
```

3. Setup database
```ruby
bin/rails db:setup
```

## Running the project

```ruby
bin/dev
```

## Testing scenarios

### Setup
1. Open the web app on your browser:

`http://localhost:3000`

2. You will be asked to allow location access on your browser as soon as the page loads.

### With a cached location

1. Check you rails console and run the following:

```ruby
WeatherForecast.count # equals 2, one from the seeds and current location on page load
WeatherForecast.first.response.fetch("name") # Chicago
```

2. Input Chicago and select Illinois in the dropdown and hit the "Submit" button

3. Go to your rails console again and run the following:

```ruby
WeatherForecast.count # still equals 2
```

### Without a cached location

1. Check you rails console and run the following:

```ruby
WeatherForecast.count # equals 2
```

2. Input Miami and select Florida in the dropdown and hit the "Submit" button

3. Go to your rails console again and run the following:

```ruby
WeatherForecast.count # equals 3
WeatherForecast.last.response.fetch("name") # Miami
```

### When the city is not in the selected state

1. Input Miami and select Illinois in the dropdown and hit the "Submit" button

2. You should see an error message like the following:
"The city may not exist in this State, try a different State?"

3. Go to your rails console, no records should have been created

```ruby
WeatherForecast.count # 3 same as the scenario above
```

## Running specs

```ruby
rspec spec

Finished in 1.06 seconds (files took 1.41 seconds to load)
27 examples, 0 failures
```
