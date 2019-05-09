import { LitElement, html, customElement, property } from 'lit-element'
import { repeat } from 'lit-html/directives/repeat'

@customElement('location-input')
class LocationInput extends LitElement {
  @property() inputId = ''
  @property() name = ''

  @property() searchResult = []

  @property({ attribute: 'location-name' })
  locationName = ''

  @property({ attribute: 'location-id' })
  locationId = ''

  @property({ attribute: 'place-id' })
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
        ${repeat(
          this.searchResult,
          place => place.place_id,
          place =>
            html`
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
        )}
      </ul>
    `
  }
}

export default LocationInput
