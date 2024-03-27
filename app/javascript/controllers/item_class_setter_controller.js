import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static outlets = ["button-toggler"];
  static targets = ["category"];

  groups = {
    'heals': ['cleric', 'shaman'],
    'tanks': ['direlord', 'paladin', 'warrior'],
    'casts': ['druid', 'necromancer', 'summoner', 'wizard'],
    'dps': ['monk', 'ranger', 'rogue'],
    'support': ['bard', 'enchanter', 'rogue'],
  };

  connect() {
  }

  auto() {

  }

  on(e) {
    const arg = e.target.attributes['data-arg'].value
    const groups = this.groups[arg]
    this.buttonTogglerOutlets.forEach(toggler => {
      if (groups.includes(toggler.slugValue)) { toggler.enable() }
    });
  }

  off(e) {
    const arg = e.target.attributes['data-arg'].value
    const groups = this.groups[arg]
    this.buttonTogglerOutlets.forEach(toggler => {
      if (groups.includes(toggler.slugValue)) { toggler.disable() }
    });
  }
}

