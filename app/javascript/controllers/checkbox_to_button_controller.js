import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "button"];

  connect() {
    this.setButtonState();
    this.buttonTarget.classList.remove('is-loading');
  }

  change() {
    this.checkboxTarget.checked = !this.checkboxTarget.checked;
    this.setButtonState();
  }

  setButtonState() {
    if (this.checkboxTarget.checked) {
      this.buttonTarget.querySelector('i').classList.remove('fa-times', 'has-text-danger')
      this.buttonTarget.querySelector('i').classList.add('fa-check', 'has-text-success');
    } else {
      this.buttonTarget.querySelector('i').classList.add('fa-times', 'has-text-danger')
      this.buttonTarget.querySelector('i').classList.remove('fa-check', 'has-text-success');
    }
  }
}

