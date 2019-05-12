import { LitElement, html, customElement, property } from 'lit-element'

@customElement('picture-input')
class PictureInput extends LitElement {
  @property() inputId = ''
  @property() value = ''
  @property() name = ''
  @property() file = null

  /**
   * @return {string}
   */
  get src() {
    return this.file ? URL.createObjectURL(this.file) : this.value
  }

  /**
   * @param {Event & { target: HTMLInputElement }} e
   */
  handleInputChange(e) {
    let file = e.target.files && e.target.files[0]

    if (file != null) {
      this.file = file
    }
  }

  createRenderRoot() {
    return this
  }

  render() {
    return html`
      <label>
        <img
          src="${this.src || '/images/placeholder.svg'}"
          alt=""
          decoding="async"
        />
        <input
          type="file"
          id="${this.inputId}"
          name="${this.name}"
          accept="image/jpeg,image/png,.jpg,.jpeg,.png"
          @change="${this.handleInputChange}"
        />
      </label>
    `
  }
}

export default PictureInput
