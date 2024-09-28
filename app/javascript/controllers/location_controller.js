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
      const lon = crd.longitude;
      const lat = crd.latitude;
      var element = document.getElementById("weather");

      fetch(`/?lat=${lat}&lon=${lon}`, {
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
