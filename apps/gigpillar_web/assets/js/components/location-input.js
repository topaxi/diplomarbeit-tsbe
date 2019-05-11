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
 * @property {number | null} id
 * @property {string} name
 * @property {string | null} google_place_id
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
   * @type {Gigpillar.Location | null} location
   */
  @property({ attribute: 'value', type: Object })
  location = null

  /**
   * @param {Event} event
   */
  selectLocation(event) {
    let [
      {
        dataset: { name, googlePlaceId }
      }
    ] = event.composedPath()

    this.location = { id: null, name, google_place_id: googlePlaceId }
  }

  /**
   * @param {CustomEvent} event
   */
  handleSearchResult({ detail: { result } }) {
    this.searchResult = result
  }

  handleClear() {
    this.location = null
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
          data-name="${place.description}"
          data-google-place-id="${place.place_id}"
          @click="${this.selectLocation}"
        >
          ${place.description}
        </button>
      </li>
    `
  }

  render() {
    if (this.location !== null) {
      return html`
        <div class="input-group">
          <input
            readonly
            id="${this.inputId}"
            name="${this.name}[name]"
            value="${this.location.name}"
          />
          <button
            type="button"
            class="input-group-addon input-group-addon-clear"
            @click="${this.handleClear}"
          >
            <span class="sr-only">Select new location</span>
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        ${this.location.id
          ? html`
              <input
                name="${this.name}[id]"
                type="hidden"
                value="${this.location.id}"
              />
            `
          : ''}
        <input
          name="${this.name}[google_place_id]"
          type="hidden"
          value="${this.location.google_place_id}"
        />
      `
    }

    return html`
      <with-dropdown>
        <search-box
          inputId="${this.inputId}"
          src="/api/autocomplete/location"
          @search-result="${this.handleSearchResult}"
        ></search-box>

        <ul class="autocomplete-result" slot="dropdown">
          ${repeat(this.searchResult, prop('place_id'), place =>
            this.renderPlaceAutocomplete(place)
          )}
        </ul>
      </with-dropdown>
    `
  }
}

export default LocationInput
