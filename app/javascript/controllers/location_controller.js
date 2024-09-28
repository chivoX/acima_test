import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="location"
export default class extends Controller {
  connect() {
    const options = {
      enableHighAccuracy: true,
      timeout: 5000,
      maximumAge: 0,
    };

    function success(pos) {
      const crd = pos.coords;
      const longitude = crd.longitude;
      const latitude = crd.latitude;
      var element = document.getElementById("weather");

      fetch(`/?lat=${latitude}&lon=${longitude}`, {
        contentType: 'application/json',
        hearders: 'application/json'
      })
      .then((response) => response.text())
      .then(res => {
        element.innerHTML = res;
      })
    }

    function error(err) {
      console.warn(`ERROR(${err.code}): ${err.message}`);
    }

    navigator.geolocation.getCurrentPosition(success, error, options);

  }
}
