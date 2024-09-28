import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="fetch-weather-by-name"
export default class extends Controller {
  static targets = [ "query" ];

  fetchWeather() {
    const element = this.queryTarget;
    const weather = document.getElementById("weather");
    const query = element.value;
    fetch(`/fetch_forecast?query=${query}`, {
      contentType: 'application/json',
      hearders: 'application/json'
    })
    .then((response) => response.text())
    .then(res => {
      weather.innerHTML = res;
    })
  }
}
