import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // copper, silver, gold, plat
  static targets = ["copperPrice", "c", "s", "g", "p"]

  connect() {
    this.updateSplits();
  }

  updateSplits() {
    if (this.copperPriceTarget.value != null) {
      this.cTarget.value = this.copperPriceTarget.value % 100;
      this.sTarget.value = Math.floor(this.copperPriceTarget.value / 100) % 100;
      this.gTarget.value = Math.floor(this.copperPriceTarget.value / 10000) % 100;
      this.pTarget.value = Math.floor(this.copperPriceTarget.value / 1000000) % 100;
    }
  }

  updateCopperPrice() {
    var copperPrice =
      Number(this.pTarget.value) * 1000000 +
      Number(this.gTarget.value) * 10000 +
      Number(this.sTarget.value) * 100 +
      Number(this.cTarget.value);

    this.copperPriceTarget.value = copperPrice;
  }
}
