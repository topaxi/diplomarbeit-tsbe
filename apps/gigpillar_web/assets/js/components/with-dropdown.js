import { LitElement, html, customElement, property, css } from 'lit-element'
import Popper from 'popper.js'

@customElement('with-dropdown')
class WithDropdown extends LitElement {
  static get styles() {
    return css`
      .dropdown {
        z-index: 1000;
        background: var(--color-background);
        border: 1px solid var(--color-foreground);
      }

      .dropdown:empty,
      .dropdown.closed {
        display: none;
      }
    `
  }

  /**
   * @type {boolean} open
   */
  @property() open = true

  /**
   * @type {Popper | null}
   */
  popper = null

  /**
   * @type {MutationObserver | null}
   */
  mutationObserver = null

  get dropdownElement() {
    return this.shadowRoot.querySelector('.dropdown')
  }

  firstUpdated() {
    this.popper = new Popper(this, this.dropdownElement, {
      placement: 'bottom-start'
    })

    this.mutationObserver = new MutationObserver(() =>
      this.popper.scheduleUpdate()
    )
    this.mutationObserver.observe(this.dropdownElement, {
      attributes: true,
      childList: true,
      subtree: true
    })
  }

  connectedCallback() {
    super.connectedCallback()

    this.addEventListener('click', this)
    this.addEventListener('focus', this)
    document.addEventListener('click', this, true)
    document.addEventListener('keydown', this, true)
  }

  disconnectedCallback() {
    super.disconnectedCallback()

    document.removeEventListener('click', this, true)
    document.removeEventListener('keydown', this, true)

    if (this.popper !== null) {
      this.popper.destroy()
    }

    if (this.mutationObserver !== null) {
      this.mutationObserver.disconnect()
    }
  }

  /**
   * @param {Event} e
   */
  handleEvent(e) {
    if (e.target === document.body) {
      switch (e.type) {
        case 'click':
          if (!e.target.contains(this.dropdownElement)) {
            this.open = false
          }
          break
        case 'keydown':
          if (e.key === 'Escape') {
            this.open = false
          }
          break
      }

      return
    }

    switch (e.type) {
      case 'click':
      case 'focus':
        this.open = true
        break
    }
  }

  render() {
    return html`
      <slot></slot>
      <div class="dropdown ${this.open ? 'open' : 'closed'}">
        <slot name="dropdown"></slot>
      </div>
    `
  }
}

export default WithDropdown
