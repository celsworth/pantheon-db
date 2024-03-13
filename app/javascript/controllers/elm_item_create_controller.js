import { Elm } from '../Item/Create.elm';
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    if (this.init === undefined) {
      this.init = Elm.Item.Create.init({
        node: this.element,
        flags: JSON.parse(this.data.get("flags"))
      });
    }
  }

  disconnect() {
    // this.element.remove();
  }
}
