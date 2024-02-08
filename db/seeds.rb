# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
return if Zone.any?

tf = Zone.create(name: 'Thronefast')
Zone.create(name: "Avendyr's Pass")

# some shaman starter area mobs to play with
m = Monster.create(zone: tf, name: 'emerald leaf spiderling', level: 1)
Item.create(monsters: [m], name: 'Spider Fangs', weight: 0.1, vendor_copper: 19, category: 'general')
Item.create(monsters: [m], name: 'Spider Egg', weight: 0.2, vendor_copper: 23, category: 'general')
Item.create(monsters: [m], name: 'Spider Legs', weight: 0.3, vendor_copper: 32, category: 'general')

z = Monster.create(zone: tf, name: 'Zirus the Bonewalker', elite: true, named: true, level: 13)
Npc.create(zone: tf, name: 'The Scavenger')

s = Item.create(monsters: [z], name: "Gnossa's Walking Stick", weight: 4.0, vendor_copper: 1750, category: 'weapon')
Stat.create(item: s, stat: 'intellect', amount: 1)
Stat.create(item: s, stat: 'spell-crit-chance', amount: 2)
Stat.create(item: s, stat: 'damage', amount: 22) # is this always physical?
Stat.create(item: s, stat: 'delay', amount: 5.9)
# stave weapon
# two-handed quarter staff
