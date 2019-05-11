import { LitElement, html, customElement, property } from 'lit-element'
import { dateConverter } from '../utils'

@customElement('datetime-input')
class DatetimeInput extends LitElement {
  @property() inputId = ''
  @property() dateLabel = ''
  @property() timeLabel = ''
  @property() name = ''

  /**
   * @type {Date | null} value
   */
  @property({ converter: dateConverter })
  value = null

  /**
   * @param {Event & { target: HTMLInputElement }} e
   */
  handleDateInput(e) {
    let d = new Date(e.target.value)

    if (this.value instanceof Date) {
      this.value.setFullYear(d.getFullYear())
      this.value.setMonth(d.getMonth())
      this.value.setDate(d.getDate())
      this.performUpdate()
    } else {
      this.value = d
    }
  }

  /**
   * @param {Event & { target: HTMLInputElement }} e
   */
  handleTimeInput(e) {
    if (this.value === null) {
      this.value = new Date()
    }

    let [hours, minutes] = e.target.value.split(':')

    this.value.setHours(Number(hours))
    this.value.setMinutes(Number(minutes))

    this.performUpdate()
  }

  /**
   * @param {Date | null} date
   */
  formatDate(date) {
    if (date === null) return null

    return `${date.getFullYear()}-${(date.getMonth() + 1)
      .toString()
      .padStart(2, '0')}-${date
      .getDate()
      .toString()
      .padStart(2, '0')}`
  }

  /**
   * @param {Date | null} date
   */
  formatTime(date) {
    if (date === null) return null

    return `${date
      .getHours()
      .toString()
      .padStart(2, '0')}:${date
      .getMinutes()
      .toString()
      .padStart(2, '0')}`
  }

  /**
   * @param {Date | null} date
   */
  formatUTCDateTime(date) {
    if (date === null) return null

    return date.toJSON()
  }

  createRenderRoot() {
    return this
  }

  render() {
    return html`
      <div class="form-control">
        <label for="${this.inputId}">${this.dateLabel}</label>
        <input
          id="${this.inputId}"
          type="date"
          value="${this.formatDate(this.value)}"
          @input="${this.handleDateInput}"
        />
      </div>

      <label class="form-control">
        ${this.timeLabel}
        <input
          type="time"
          value="${this.formatTime(this.value)}"
          @input="${this.handleTimeInput}"
        />
      </label>

      <input
        type="hidden"
        name="${this.name}"
        value="${this.formatUTCDateTime(this.value)}"
      />
    `
  }
}

export default DatetimeInput
