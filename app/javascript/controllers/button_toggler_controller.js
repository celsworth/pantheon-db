import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "button"];

  static values = {
    onClasses: Array,
    offClasses: Array
  }

  connect() {
    this.setButtonState();
  }

  toggle() {
    this.inputTarget.value = this.inputTarget.value == 'true' ? 'false' : 'true';
    this.setButtonState();
  }

  setButtonState() {
    if (this.inputTarget.value == 'true') {
      this.buttonTarget.classList.add(...this.onClassesValue);
      this.buttonTarget.classList.remove(...this.offClassesValue);
    } else {
      this.buttonTarget.classList.remove(...this.onClassesValue);
      this.buttonTarget.classList.add(...this.offClassesValue);
    }
  }
}

