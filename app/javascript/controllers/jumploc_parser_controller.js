import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["jumploc", "x", "y", "z"];

  change() {
    // /jumploc 3453.94 476.00 3770.94 58
    var parts = this.jumplocTarget.value.split(' ');

    if (parts[0] == '/jumploc' && parts.length == 5) {
      this.xTarget.value = parts[2];
      this.zTarget.value = parts[3];
      this.yTarget.value = parts[4];
    }
  }
}

