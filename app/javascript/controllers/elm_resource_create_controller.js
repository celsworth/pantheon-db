import { Elm } from '../Resource/Create.elm';
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="elm-resource-create"
export default class extends Controller {
  connect() {
    if (this.init === undefined) {
      this.init = Elm.Resource.Create.init({
        node: this.element,
        flags: JSON.parse(this.data.get("flags"))
      });
    }
  }

  disconnect() {
    // this.element.remove();
  }
}
