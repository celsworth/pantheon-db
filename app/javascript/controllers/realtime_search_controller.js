import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  timeout = null;

  connect() {
  }

  search() {
    var e = this.element;

    clearTimeout(this.timeout);
    this.timeout = setTimeout(function() {
      const qs = new URLSearchParams(new FormData(e));
      const documentURL = new URL(document.location.href);
      const searchParams = documentURL.searchParams;
      for (const [key, value] of qs) {
        if (value == "") {
          searchParams.delete(key);
        } else {
          searchParams.set(key, value);
        }
      };

      history.replaceState(null, null, documentURL.href);

      e.requestSubmit();

    }, 300);
  }
}

