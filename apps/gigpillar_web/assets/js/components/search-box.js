import { fromEvent, Subject } from 'rxjs'
import { fromFetch } from 'rxjs/fetch'
import { takeUntil, debounceTime, map, switchMap } from 'rxjs/operators'
import { LitElement, html, customElement, property } from 'lit-element'

@customElement('search-box')
class SearchBox extends LitElement {
  @property() inputId = ''
  @property() query = ''
  @property() src = ''
  @property() name = ''
  @property() placeholder = ''

  @property({ attribute: 'debounce-time', converter: Number })
  debounceTime = 200

  destroy = new Subject()

  createRenderRoot() {
    return this
  }

  connectedCallback() {
    super.connectedCallback()

    fromEvent(this, 'input')
      .pipe(
        takeUntil(this.destroy),
        debounceTime(this.debounceTime),
        map(event => event.target.value),
        switchMap(query => fromFetch(`${this.src}?query=${query}`)),
        switchMap(response => response.json())
      )
      .subscribe(result => {
        console.log(result)
      })
  }

  disconnectedCallback() {
    super.disconnectedCallback()

    this.destroy.next()
  }

  render() {
    return html`
      <span class="search-icon"></span>
      <input
        id="${this.inputId}"
        type="search"
        name="${this.name}"
        value="${this.query}"
        placeholder="${this.placeholder}"
      />
      <slot></slot>
    `
  }
}

export default SearchBox
