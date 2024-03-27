import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["category", "select", "selectedId"];

  static values = {
    url: String
  }

  connect() {
  }

  load() {
    const urlParams = new URLSearchParams();
    urlParams.set('category', this.categoryTarget.value);
    urlParams.set('selected_id', this.selectedIdTarget.value);
    this.selectTarget.src = this.urlValue + '?' + urlParams.toString();
  }
}

