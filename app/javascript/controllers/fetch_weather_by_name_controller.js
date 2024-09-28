import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="fetch-weather-by-name"
export default class extends Controller {
  static targets = [ "city", "state" ];

  fetchWeather() {
    const cityElement = this.cityTarget;
    const stateElement = this.stateTarget;
    const weather = document.getElementById("weather");
    const city = cityElement.value;
    const state = stateElement.options[stateElement.selectedIndex].value;

    fetch(`/fetch_forecast?city=${city}&state=${state}`, {
      contentType: 'application/json',
      hearders: 'application/json'
    })
    .then((response) => response.text())
    .then(res => {
      weather.innerHTML = res;
    })
  }
}
