import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["locationCategory", "locationSelect", "selectedId"];

  static values = {
    url: String
  }

  connect() {
  }

  load() {
    const urlParams = new URLSearchParams();
    urlParams.set('category', this.locationCategoryTarget.value);
    urlParams.set('selected_id', this.selectedIdTarget.value);
    this.locationSelectTarget.src = this.urlValue + '?' + urlParams.toString();
  }
}

