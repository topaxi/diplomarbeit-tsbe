import { Subject, EMPTY } from 'rxjs'
import { ajax } from 'rxjs/ajax'
import {
  takeUntil,
  debounceTime,
  map,
  switchMap,
  catchError
} from 'rxjs/operators'
import { LitElement, html, customElement, property } from 'lit-element'

@customElement('search-box')
class SearchBox extends LitElement {
  @property() inputId = ''
  @property() src = ''
  @property() name = ''
  @property() placeholder = ''

  @property({ attribute: 'debounce-time', converter: Number })
  debounceTime = 200

  query = new Subject()
  destroy = new Subject()

  createRenderRoot() {
    return this
  }

  connectedCallback() {
    this.style.display = 'block'

    super.connectedCallback()

    this.query
      .pipe(
        takeUntil(this.destroy),
        debounceTime(this.debounceTime),
        switchMap(query =>
          ajax(`${this.src}?query=${query}`).pipe(
            map(req => this.createResultEvent(req.response)),
            catchError(err => {
              console.error(err)

              return EMPTY
            })
          )
        )
      )
      .subscribe(event => this.dispatchEvent(event), err => console.error(err))
  }

  /**
   * @param {object} result
   */
  createResultEvent(result) {
    return new CustomEvent('search-result', {
      detail: { result },
      bubbles: true,
      composed: true
    })
  }

  disconnectedCallback() {
    super.disconnectedCallback()

    this.destroy.next()
  }

  /**
   * @param {Event & { target: HTMLInputElement }} event
   */
  handleInput(event) {
    this.query.next(event.target.value)
  }

  render() {
    return html`
      <span class="search-icon"></span>
      <input
        id="${this.inputId}"
        type="search"
        name="${this.name}"
        placeholder="${this.placeholder}"
        @input="${this.handleInput}"
      />
    `
  }
}

export default SearchBox
