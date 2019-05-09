import { LitElement, html, customElement, property, css } from 'lit-element'

const placeholder = html`
  <svg class="placeholder" viewBox="0 0 512 512">
    <path
      d="M8.53 17.07h494.94a8.53 8.53 0 1 0 0-17.07H8.53a8.54 8.54 0 0 0 0 17.07zM315.73 290.13a8.53 8.53 0 1 0 0-17.06 42.72 42.72 0 0 0-42.66 42.66 42.72 42.72 0 0 0 42.66 42.67 42.72 42.72 0 0 0 42.67-42.67v-153.6a8.52 8.52 0 0 0-10.6-8.27l-136.54 34.13a8.53 8.53 0 0 0-6.46 8.28v153.6c0 14.11-11.49 25.6-25.6 25.6s-25.6-11.49-25.6-25.6 11.49-25.6 25.6-25.6a8.54 8.54 0 0 0 0-17.07 42.72 42.72 0 0 0-42.67 42.67c0 23.52 19.14 42.66 42.67 42.66s42.67-19.14 42.67-42.66V240.58l104.57-27.53a8.53 8.53 0 0 0-4.35-16.5l-100.22 26.38v-20l119.46-29.87v142.67c0 14.12-11.48 25.6-25.6 25.6s-25.6-11.48-25.6-25.6 11.49-25.6 25.6-25.6zM506.73 34.79a8.54 8.54 0 0 0-9.3 1.85l-70.76 70.76V42.67a8.53 8.53 0 1 0-17.07 0v426.66a8.59 8.59 0 0 0 8.53 8.53 8.53 8.53 0 0 0 6.04-2.5l70.77-70.76v64.73a8.53 8.53 0 1 0 17.06 0V42.67a8.6 8.6 0 0 0-5.27-7.88zm-80.06 101.74h56.2l-56.2 56.2v-56.2zm0 85.34h56.2l-56.2 56.2v-56.2zm0 85.33h56.2l-56.2 56.2v-56.2zm0 141.53v-56.2h56.2l-56.2 56.2zm68.26-73.26h-56.2l56.2-56.2v56.2zm0-85.34h-56.2l56.2-56.2v56.2zm0-85.33h-56.2l56.2-56.2v56.2zm0-85.33h-56.2l56.2-56.2v56.2zM503.47 494.93H8.53a8.54 8.54 0 0 0 0 17.07h494.94a8.53 8.53 0 1 0 0-17.07zM5.27 477.21a8.46 8.46 0 0 0 9.3-1.84l70.76-70.77v64.73a8.54 8.54 0 0 0 17.07 0V42.67a8.61 8.61 0 0 0-5.27-7.88 8.54 8.54 0 0 0-9.3 1.84L17.06 107.4V42.67a8.54 8.54 0 0 0-17.07 0v426.66a8.61 8.61 0 0 0 5.27 7.88zm80.06-101.74h-56.2l56.2-56.2v56.2zm0-85.34h-56.2l56.2-56.2v56.2zm0-85.33h-56.2l56.2-56.2v56.2zm0-141.53v56.2h-56.2l56.2-56.2zm-68.26 73.26h56.2l-56.2 56.2v-56.2zm0 85.34h56.2l-56.2 56.2v-56.2zm0 85.33h56.2l-56.2 56.2v-56.2zm0 85.33h56.2l-56.2 56.2v-56.2z"
    />
  </svg>
`

@customElement('picture-input')
class PictureInput extends LitElement {
  static get styles() {
    return css`
      img,
      svg {
        max-width: 100%;
        max-height: 160px;
      }

      .placeholder {
        width: 160px;
      }

      label {
        display: inline-block;
        cursor: pointer;
      }

      input {
        width: 1px;
        height: 1px;
        opacity: 0;
      }
    `
  }

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
      e.target.value = ''
    }
  }

  render() {
    return html`
      <label>
        ${this.src
          ? html`
              <img src="${this.src}" alt="" decoding="async" />
            `
          : placeholder}
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
