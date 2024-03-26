import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['form', 'turboFrame', 'addStat']

  static values = {
    url: String
  }

  connect() {
  }

  qsFromForm() {
    return new URLSearchParams(new FormData(this.formTarget));
  }

  change_category() {
    const queryString = this.qsFromForm();
    this.turboFrameTarget.src = this.urlValue + '?' + queryString.toString();
  }

  add_stat() {
    const queryString = this.qsFromForm();
    queryString.set('add_stat', this.addStatTarget.value);
    this.turboFrameTarget.src = this.urlValue + '?' + queryString.toString();
  }

  remove_stat(event) {
    const queryString = this.qsFromForm();
    queryString.set('remove_stat', event.params['removeStatKey']);
    this.turboFrameTarget.src = this.urlValue + '?' + queryString.toString();
  }
}
