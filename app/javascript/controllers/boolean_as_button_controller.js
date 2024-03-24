import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "button"];

  connect() {
    this.setButtonState();
    this.buttonTarget.classList.remove('is-loading');
  }

  change() {
    // this isn't a real input, it's a hidden field that can have
    // value="on" or value=""
    this.inputTarget.value = this.inputTarget.value == 'on' ? '' : 'on';
    this.setButtonState();
  }

  setButtonState() {
    if (this.inputTarget.value == 'on') {
      this.buttonTarget.querySelector('i').classList.remove('fa-times', 'has-text-danger')
      this.buttonTarget.querySelector('i').classList.add('fa-check', 'has-text-success');
    } else {
      this.buttonTarget.querySelector('i').classList.add('fa-times', 'has-text-danger')
      this.buttonTarget.querySelector('i').classList.remove('fa-check', 'has-text-success');
    }
  }
}

