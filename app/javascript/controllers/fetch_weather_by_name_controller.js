import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="fetch-weather-by-name"
export default class extends Controller {
  static targets = [ "city", "state", "errors" ];

  fetchWeather() {
    const cityElement = this.cityTarget;
    const stateElement = this.stateTarget;
    const errorsElement = this.errorsTarget;
    const weather = document.getElementById("weather");
    const city = cityElement.value.toLowerCase();
    const state = stateElement.options[stateElement.selectedIndex].value.toLowerCase();

    fetch(`/fetch_forecast?city=${city}&state=${state}`, {
      contentType: 'application/json',
      hearders: 'application/json'
    })
    .then((response) => response.text())
    .then(res => {
      const service_response = JSON.parse(res);
      if (service_response.status == true) {
        weather.innerHTML = service_response.result;
        errorsElement.innerHTML = '';
      } else {
        errorsElement.innerHTML = service_response.errors;
      }
    })
  }
}
