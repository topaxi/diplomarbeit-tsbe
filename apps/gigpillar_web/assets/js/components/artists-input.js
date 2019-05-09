import { LitElement, html, customElement, property } from 'lit-element'
import { repeat } from 'lit-html/directives/repeat'
import { prop, includedIn, not } from '../utils'

@customElement('artists-input')
class ArtistsInput extends LitElement {
  @property() inputId = ''
  @property() name = ''
  @property() searchResult = []

  /**
   * @type {object[]} artists
   */
  @property({ attribute: 'artists', converter: value => JSON.parse(value) })
  artists = []

  /**
   * @param {Event} event
   */
  addArtist(event) {
    let [
      {
        dataset: { id, name }
      }
    ] = event.composedPath()

    id = Number(id)

    if (this.artists.every(a => a.id !== id)) {
      this.artists = [...this.artists, { id, name }]
    }
  }

  /**
   * @param {Event} event
   */
  removeArtist({ target }) {
    let { id } = target.closest('button').dataset

    id = Number(id)

    this.artists = this.artists.filter(a => a.id !== id)
  }

  /**
   * @param {CustomEvent} event
   */
  handleSearchResult({ detail: { result } }) {
    this.searchResult = result
  }

  createRenderRoot() {
    return this
  }

  render() {
    return html`
      <ul class="form-artist-list">
        ${repeat(
          this.artists,
          prop('id'),
          (artist, i) => html`
            <li>
              ${artist.name}
              <label
                >at
                <input
                  type="time"
                  name="${this.name}[${i}][plays_at]"
                  value="${artist.plays_at}"
              /></label>
              <button
                type="button"
                data-id="${artist.id}"
                @click="${this.removeArtist}"
              >
                <span class="sr-only"
                  >Remove ${artist.name} from this event.</span
                ><span aria-hidden="true">&times;</span>
              </button>
              <input
                type="hidden"
                name="${this.name}[${i}][id]"
                value="${artist.id}"
              />
            </li>
          `
        )}
      </ul>

      <search-box
        inputId="${this.inputId}"
        src="/api/autocomplete/artist"
        @search-result="${this.handleSearchResult}"
      ></search-box>

      <ul class="autocomplete-result">
        ${repeat(
          this.searchResult.filter(not(includedIn(this.artists, prop('id')))),
          prop('id'),
          artist =>
            html`
              <li>
                <button
                  type="button"
                  data-name="${artist.name}"
                  data-id="${artist.id}"
                  @click="${this.addArtist}"
                >
                  ${artist.name}
                </button>
              </li>
            `
        )}
      </ul>
    `
  }
}
