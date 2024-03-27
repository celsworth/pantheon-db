import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = ['on', 'off'];
  static targets = ["input", "button"];
  static values = { "slug": String };


  connect() {
    this.setButtonState();
  }

  toggle() {
    this.inputTarget.value = this.inputTarget.value == 'true' ? 'false' : 'true';
    this.setButtonState();
  }

  enable() {
    this.inputTarget.value = 'true';
    this.setButtonState();
  }

  disable() {
    this.inputTarget.value = 'false';
    this.setButtonState();
  }

  setButtonState() {
    if (this.inputTarget.value == 'true') {
      this.buttonTarget.classList.add(...this.onClasses);
      this.buttonTarget.classList.remove(...this.offClasses);
    } else {
      this.buttonTarget.classList.remove(...this.onClasses);
      this.buttonTarget.classList.add(...this.offClasses);
    }
  }
}

