import { Controller } from "stimulus"
import 'mapbox-gl/dist/mapbox-gl.css'
import mapboxgl from '!mapbox-gl'

export default class extends Controller {
  static targets = [ "lng", "lat", "container" ]

  connect() {
    mapboxgl.accessToken = 'pk.eyJ1IjoicGF0cmlja2xpbmRzYXkiLCJhIjoiY2p6aHd4am1mMGI0YjNvbngwMW8xdm1jMiJ9.MiLAC_Vh_wO0ugv3M7wa1A';
    this.map = new mapboxgl.Map({
      container: this.containerTarget,
      style: 'mapbox://styles/mapbox/streets-v11',
      center: this._defaultCoordinates(),
      zoom: 14
    });

    this.marker = new mapboxgl.Marker().setLngLat(this._defaultCoordinates()).addTo(this.map)
    this.map.on('click', (ev) => {
      this.lngTarget.value = ev.lngLat.lng
      this.latTarget.value = ev.lngLat.lat

      this.marker.setLngLat([ev.lngLat.lng, ev.lngLat.lat])
    })
  }

  clear() {
    this.lngTarget.value = ''
    this.latTarget.value = ''
  }

  apply() {
    this.lngInput.value = this.lngTarget.value
    this.latInput.value = this.latTarget.value

    bootstrap.Modal.getInstance(this.element).hide()
  }

  open() {
    this.lngInput = document.querySelector(`${window.coordinateSelectorWrapper} .js-input-lng`)
    this.latInput = document.querySelector(`${window.coordinateSelectorWrapper} .js-input-lat`)
    this.lngTarget.value = this._initialCoordinates()[0]
    this.latTarget.value = this._initialCoordinates()[1]

    this.map.resize()
    this.marker.setLngLat(this._initialCoordinates())
    this.map.flyTo({ center: this._initialCoordinates() })
  }

  updateStyle(event) {
    this.map.setStyle(`mapbox://styles/mapbox/${event.currentTarget.value}`)
  }

  _initialCoordinates() {
    if (this._isCoordinatesSupplied()) {
      return [this.lngInput.value, this.latInput.value]
    } else {
      return [140.7069043, 42.8601737]
    }
  }

  _isCoordinatesSupplied() {
    return this.lngInput.value != '' && this.latInput.value != ''
  }

  _defaultCoordinates() {
    return [140.7069043, 42.8601737]
  }
}
