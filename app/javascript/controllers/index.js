// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import FetchWeatherByNameController from "./fetch_weather_by_name_controller"
application.register("fetch-weather-by-name", FetchWeatherByNameController)

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import LocationController from "./location_controller"
application.register("location", LocationController)
