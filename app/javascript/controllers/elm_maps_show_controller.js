import { Elm } from '../Maps/Show.elm';
import { Controller } from "@hotwired/stimulus"

/* how to get this in the class but still callable from the port?? */
function preventScrolling(e) {
  e.preventDefault();
};

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

      this.init.ports.preventScrolling.subscribe(function(b) {
        if (b) {
          document.addEventListener('touchmove', preventScrolling, { passive: false });
        } else {
          document.removeEventListener('touchmove', preventScrolling);
        }
      });
    }
  }

  disconnect() {
    // this.element.remove();
  }
}
