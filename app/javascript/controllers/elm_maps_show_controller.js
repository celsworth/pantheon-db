import { Elm } from '../Maps/Show.elm';
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  replaceStateTimeoutId = null;

  connect() {
    if (this.init === undefined) {
      this.init = Elm.Maps.Show.init({
        node: this.element,
        flags: JSON.parse(this.data.get("flags"))
      });

      this.init.ports.pushUrl.subscribe(function(url) {
        clearTimeout(this.replaceStateTimeoutId);
        this.replaceStateTimeoutId = setTimeout(function() {
          history.replaceState({}, '', url);
        }, 200);
      });

    }
  }

  disconnect() {
    // this.element.remove();
  }
}
