import { Elm } from '../Maps/Show.elm';
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="elm-resource-create"
export default class extends Controller {
  connect() {
    if (this.init === undefined) {
      this.init = Elm.Maps.Show.init({
        node: this.element,
        flags: JSON.parse(this.data.get("flags"))
      });
    }
  }

  disconnect() {
    // this.element.remove();
  }
}