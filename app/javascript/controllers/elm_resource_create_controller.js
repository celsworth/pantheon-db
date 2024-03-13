import { Elm } from '../Resource/Create.elm';
import { Controller } from "@hotwired/stimulus"

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
