# frozen_string_literal: true

return if Zone.any?

Patch.create(version: '0.13.85')
Patch.create(version: '0.13.207')

avp = Zone.create(name: "Avendyr's Pass")
z = Zone.create(name: 'Thronefast')
availia = Location.create(zone: z, settlement: Settlement.create(name: 'Availia'))
Location.create(zone: avp, settlement: Settlement.create(name: 'Demith'))
tf = Location.create(zone: z)

huntress = Npc.create(location: availia, name: 'The Huntress')
scavenger = Npc.create(location: availia, name: 'The Scavenger')
clothier = Npc.create(location: availia, name: 'The Clothier')

i = Item.create(name: 'A Mysterious Letter', category: 'clickie', weight: 0, required_level: 1)
q = Quest.create(
  name: '(Tradeskills) A mysterious letter',
  text: "You do not know me, but I have an opportunity for you. Find me near the well in the center of the village of Avalia and I will explain more.

  Until we meet,
  -The Scavenger",
  receiver: scavenger,
  dropped_as: i
)

i1 = Item.create(name: 'Schematic: Burlap Cloth', category: 'schematic', weight: 0, required_level: 1)
i2 = Item.create(name: 'Schematic: Burlap Cord', category: 'schematic', weight: 0, required_level: 1)
i3 = Item.create(name: 'Schematic: Burlap Thread', category: 'schematic', weight: 0, required_level: 1)
i4 = Item.create(name: 'Schematic: Burlap Padding', category: 'schematic', weight: 0, required_level: 1)
q = Quest.create(name: '(Outfitter) Learning Outfitting', text: 'some text',
                 giver: clothier, receiver: clothier)
QuestReward.create(quest: q, item: i1)
QuestReward.create(quest: q, item: i2)
QuestReward.create(quest: q, item: i3)
QuestReward.create(quest: q, item: i4)
QuestReward.create(quest: q, copper: true, amount: 50)
QuestReward.create(quest: q, standing: true, amount: 0.08)

q = Quest.create(prereq_quest: q,
                 name: '(Outfitter) Loom Practice', text: 'some text',
                 giver: clothier, receiver: clothier)
i = Item.create(name: 'Schematic: Tattered Leather', category: 'schematic', weight: 0, required_level: 1)
QuestReward.create(quest: q, item: i)

# some shaman starter area mobs to play with
m = Monster.create(location: tf, name: 'emerald leaf spiderling', level: 1)
Item.create(dropped_by: [m], name: 'Spider Fangs', weight: 0.1, sell_price: 19, category: 'general')
Item.create(dropped_by: [m], name: 'Spider Egg', weight: 0.2, sell_price: 23, category: 'general')
Item.create(dropped_by: [m], name: 'Spider Legs', weight: 0.3, sell_price: 32, category: 'general')

m = Monster.create(location: tf, name: 'elder greatpaw', level: 10, named: true)
i = Item.create(dropped_by: [m], name: 'Bear Paw', weight: 0.1, category: 'general')
Quest.create(text: 'todo', receiver: huntress, name: 'Bear Paw Quest', dropped_as: i)

m = Monster.create(location: tf, name: 'a jacked rabbit', level: 10, named: true)
i = Item.create(dropped_by: [m], name: 'Tarnished Band', weight: 0.1, category: 'jewellery',
                slot: 'fingers', stats: { agility: 2 }, attrs: %w[magic])

m = Monster.create(location: tf, name: 'Zirus the Bonewalker', elite: true, named: true, level: 13)
i = Item.create(dropped_by: [m], name: "Gnossa's Walking Stick",
                stats: { intellect: 1, 'spell-crit-chance': 2, damage: 22, delay: 5.9 },
                weight: 4.0, sell_price: 1750, category: 'stave-weapon', attrs: %w[magic])
# two-handed quarter staff
#
i = Item.create(name: 'Tattered Pelt', weight: 0.8, category: 'resource')

i = Item.create(name: 'Blood-Soaked Shield', weight: 6.5, category: 'shield',
                required_level: 6,
                stats: { armor: 4, 'block-rating': 155, stamina: 1 },
                attrs: %w[magic],
                classes: %w[warrior cleric paladin ranger shaman])

Item.create(name: 'Rune of Living Stone', slot: 'relic', category: 'relic', weight: 0.2,
            stats: { dodge: 25, 'mana-recovery-while-resting': 2 },
            classes: %w[cleric wizard druid enchanter shaman summoner necromancer],
            attrs: ['magic'])
