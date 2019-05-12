import { Subject, BehaviorSubject, of } from 'rxjs'
import { ajax } from 'rxjs/ajax'
import {
  skip,
  takeUntil,
  debounceTime,
  map,
  switchMap,
  catchError
} from 'rxjs/operators'
import { LitElement, html, customElement, property } from 'lit-element'
import { prop } from '../utils'

@customElement('search-box')
class SearchBox extends LitElement {
  @property() inputId = ''
  @property() src = ''
  @property() name = ''
  @property() placeholder = ''

  /**
   * @param {string} value
   */
  @property()
  set value(value) {
    this.query.next(value)
  }

  get value() {
    return this.query.getValue()
  }

  @property({ attribute: 'debounce-time', converter: Number })
  debounceTime = 200

  query = new BehaviorSubject('')
  destroy = new Subject()

  createRenderRoot() {
    return this
  }

  connectedCallback() {
    this.style.display = 'block'

    super.connectedCallback()

    this.query
      .pipe(
        skip(1),
        takeUntil(this.destroy),
        debounceTime(this.debounceTime),
        switchMap(query =>
          query.trim() === ''
            ? of([])
            : ajax(`${this.src}?query=${query}`).pipe(
                map(prop('response')),
                catchError(err => {
                  console.error(err)

                  return of([])
                })
              )
        ),
        map(response => this.createResultEvent(response))
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
        value="${this.value}"
        autocomplete="off"
        @input="${this.handleInput}"
      />
    `
  }
}

export default SearchBox
