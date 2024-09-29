# Acima Test

This test for acima required the following challenges to be completed:

## Backend
* Implementing a weather service (I choose OpenWeatherWeatherMap.org's).

* Store responses in a database and use as cache. Valid for 1 hour.

## Frontend

* Allow location service on your browser and use your current location to look up the current weather.

* Display current location weather on first load.

* Bonus: Provide a search for weather by City/State.

## Configuration

You will need to rename .env.sample to .env and setup the database.

```ruby
bin/rails db:setup

```

## Running the project

```ruby
bin/dev
```

## Running specs

```ruby
bin/rspec specs
```
