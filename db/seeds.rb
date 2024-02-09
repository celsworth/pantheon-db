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

Patch.create(version: '0.13.85')

tf = Zone.create(name: 'Thronefast')
Zone.create(name: "Avendyr's Pass")

huntress = Npc.create(zone: tf, name: 'The Huntress')
scavenger = Npc.create(zone: tf, name: 'The Scavenger')

# some shaman starter area mobs to play with
m = Monster.create(zone: tf, name: 'emerald leaf spiderling', level: 1)
Item.create(dropped_by: [m], name: 'Spider Fangs', weight: 0.1, vendor_copper: 19, category: 'general')
Item.create(dropped_by: [m], name: 'Spider Egg', weight: 0.2, vendor_copper: 23, category: 'general')
Item.create(dropped_by: [m], name: 'Spider Legs', weight: 0.3, vendor_copper: 32, category: 'general')

m = Monster.create(zone: tf, name: 'elder greatpaw', level: 10, named: true)
i = Item.create(dropped_by: [m], name: 'Bear Paw', weight: 0.1, category: 'general')
Quest.create(text: 'todo', receiver: huntress, name: 'Bear Paw Quest', dropped_as: i)

m = Monster.create(zone: tf, name: 'a jacked rabbit', level: 10, named: true)
i = Item.create(dropped_by: [m], name: 'Tarnished Band', weight: 0.1, category: 'jewellery',
                slot: 'fingers',
                stats: { agility: 2 },
                attrs: %w[magic])

m = Monster.create(zone: tf, name: 'Zirus the Bonewalker', elite: true, named: true, level: 13)
i = Item.create(dropped_by: [m], name: "Gnossa's Walking Stick",
                stats: { intellect: 1, 'spell-crit-chance': 2, damage: 22, delay: 5.9 },
                weight: 4.0, vendor_copper: 1750,
                category: 'stave-weapon', attrs: %w[magic])
# two-handed quarter staff
#
i = Item.create(name: 'Tattered Pelt', weight: 0.8, category: 'resource')

i = Item.create(name: 'Blood-Soaked Shield', weight: 6.5, category: 'shield',
                required_level: 6,
                stats: { armor: 4, 'block-rating': 155, stamina: 1 },
                attrs: %w[magic],
                classes: %w[warrior cleric paladin ranger shaman])
