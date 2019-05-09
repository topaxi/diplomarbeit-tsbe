import { LitElement, html, customElement, property } from 'lit-element'
import { repeat } from 'lit-html/directives/repeat'
import { prop } from '../utils'

/**
 * @typedef {Object} Place
 * @property {string} place_id
 * @property {string} description
 */

/**
 * @typedef {Object} Gigpillar.Location
 * @property {number} id
 * @property {string} name
 */

@customElement('location-input')
class LocationInput extends LitElement {
  @property() inputId = ''
  @property() name = ''

  /**
   * @type {Place[]} searchResult
   */
  @property() searchResult = []

  /**
   * @param {Gigpillar.Location} value
   */
  @property({ attribute: 'value', converter: value => JSON.parse(value) })
  set location(value) {
    this.locationName = value.name
    this.locationId = String(value.id)
  }

  @property()
  locationName = ''

  @property()
  locationId = ''

  @property()
  placeId = ''

  /**
   * @param {Event} event
   */
  selectLocation(event) {
    let [
      {
        dataset: { placeId, description }
      }
    ] = event.composedPath()

    this.placeId = placeId
    this.locationName = description
    this.locationId = ''
  }

  /**
   * @param {CustomEvent} event
   */
  handleSearchResult({ detail: { result } }) {
    this.searchResult = result
  }

  handleClear() {
    this.placeId = ''
    this.locationName = ''
    this.locationId = ''
  }

  createRenderRoot() {
    return this
  }

  /**
   * @param {Place} place
   */
  renderPlaceAutocomplete(place) {
    return html`
      <li>
        <button
          type="button"
          data-description="${place.description}"
          data-place-id="${place.place_id}"
          @click="${this.selectLocation}"
        >
          ${place.description}
        </button>
      </li>
    `
  }

  render() {
    if (this.locationName) {
      return html`
        <div class="input-group">
          <input readonly id="${this.inputId}" value="${this.locationName}" />
          <button
            type="button"
            class="input-group-addon input-group-addon-clear"
            @click="${this.handleClear}"
          >
            <span class="sr-only">Select new location</span>
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <input name="${this.name}" type="hidden" value="${this.placeId}" />
      `
    }

    return html`
      <search-box
        inputId="${this.inputId}"
        src="/api/autocomplete/location"
        @search-result="${this.handleSearchResult}"
      ></search-box>

      <ul class="autocomplete-result">
        ${repeat(this.searchResult, prop('place_id'), place =>
          this.renderPlaceAutocomplete(place)
        )}
      </ul>
    `
  }
}

export default LocationInput
