import { LitElement, html, customElement, property } from 'lit-element'
import { repeat } from 'lit-html/directives/repeat'
import { prop, includedIn, not, by } from '../utils'

/**
 * @typedef {Object} Artist
 * @property {number=} id
 * @property {string} name
 * @property {string=} plays_at
 */

@customElement('artists-input')
class ArtistsInput extends LitElement {
  @property() inputId = ''
  @property() name = ''

  /**
   * @type {Artist[]} searchResult
   */
  @property() searchResult = []

  @property()
  placeholder = ''

  /**
   * @type {Artist[]} artists
   */
  @property({ attribute: 'value', type: Array })
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

    if (this.artists.every(not(by(prop('id'), id)))) {
      this.artists = [...this.artists, { id, name }]
    }
  }

  /**
   * @param {Event} event
   */
  removeArtist({ target }) {
    let { id } = target.closest('button').dataset

    id = Number(id)

    this.artists = this.artists.filter(not(by(prop('id'), id)))
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

  /**
   * @param {Artist} artist
   */
  renderArtistAutocomplete(artist) {
    return html`
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
  }

  /**
   * @param {Artist} artist
   * @param {number} i
   */
  renderArtistListItem(artist, i) {
    return html`
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
          <span class="sr-only">Remove ${artist.name} from this event.</span
          ><span aria-hidden="true">&times;</span>
        </button>
        <input type="hidden" name="${this.name}[${i}][order]" value="${i}" />
        <input
          type="hidden"
          name="${this.name}[${i}][artist_id]"
          value="${artist.id}"
        />
      </li>
    `
  }

  render() {
    return html`
      <ul class="form-artist-list">
        ${repeat(this.artists, prop('id'), (artist, i) =>
          this.renderArtistListItem(artist, i)
        )}
      </ul>

      <with-dropdown>
        <search-box
          inputId="${this.inputId}"
          src="/api/autocomplete/artist"
          placeholder="${this.placeholder}"
          @search-result="${this.handleSearchResult}"
        ></search-box>

        <ul class="autocomplete-result" slot="dropdown">
          ${repeat(
            this.searchResult.filter(
              not(includedIn(this.artists, prop('id')))
            ),
            prop('id'),
            artist => this.renderArtistAutocomplete(artist)
          )}
        </ul>
      </with-dropdown>
    `
  }
}

export default ArtistsInput
