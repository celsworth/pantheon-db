# README

Base URL for now is http://yrk.cae.me.uk:3000 - this will change eventually.

## Admin Dashboard

See /admin for a quick and dirty display to see what's in db and edit things in a UI.


## GraphQL

This is a GraphQL API; GraphiQL console is available at http://yrk.cae.me.uk:3000/graphiql


Ultimately I hope this API will be able to answer almost any question about Pantheon itemisation, NPCs, quest lines, etc.

If you want to ask the API a question it cannot answer, let me know..

Some examples below. These are using a pretty limited dataset so excuse some of the repetitiveness.


### Where are the Shaman trainers?

```graphql
{
  npcs(subtitle: "Shaman Scrolls") {
    id
    name
    locX
    locY
    locZ
  }
}
```

Output:

```json
{
  "data": {
    "npcs": [
      {
        "id": "5",
        "name": "Akola",
        "locX": 3026.21,
        "locY": 3776.17,
        "locZ": 463.57
      }
    ]
  }
}
```

There's only one for now, but note that `npcs` returns an array so we can add more as they arrive.

Eventually, a pretty frontend can plot these locs on a world map.


### Find me items with at least 1 Spell Crit Chance

```graphql
{
  items(stats: [{stat: "spell-crit-chance", operator: GTE, value: 1}]) {
    name
    stats
  }
}
```

```json
{
  "data": {
    "items": [
      {
        "name": "Gnossa's Walking Stick",
        "stats": {
          "delay": 5.9,
          "damage": 22,
          "intellect": 1,
          "spell-crit-chance": 2
        }
      }
    ]
  }
}
```

### Which quest rewards the Tattered Leather schematic, and where is the NPC that offers it?

```graphql
{
  items(name: "Tattered Leather", category: "schematic") {
    name
    rewardedFromQuests {
      name
      giver {
        name
        locX
        locY
        locZ
      }
    }
  }
}
```

Output:

```json
{
  "data": {
    "items": [
      {
        "name": "Schematic: Tattered Leather",
        "rewardedFromQuests": [
          {
            "name": "(Outfitter) Loom Practice",
            "giver": {
              "name": "The Clothier",
              "locX": 3447.21,
              "locY": 3675.61,
              "locZ": 483.33
            }
          }
        ]
      }
    ]
  }
}
```

### What items does an emerald leaf spiderling drop?

```graphql
{
  monsters(name: "emerald leaf spiderling") {
    name
    drops {
      name
      category
      weight
      sellPrice
    }
  }
}
```

```json
{
  "data": {
    "monsters": [
      {
        "name": "emerald leaf spiderling",
        "drops": [
          {
            "name": "Spider Fangs",
            "category": "general",
            "weight": 0.1,
            "sellPrice": 19
          },
          {
            "name": "Spider Egg",
            "category": "general",
            "weight": 0.2,
            "sellPrice": 23
          },
          {
            "name": "Spider Legs",
            "category": "general",
            "weight": 0.3,
            "sellPrice": 32
          }
        ]
      }
    ]
  }
}
```


### Who drops Gnossa's Walking Stick?

```graphql
{
  items(name: "Walking Stick") {
    droppedBy {
      name
    }
  }
}
```

```json
{
  "data": {
    "items": [
      {
        "droppedBy": [
          {
            "name": "Zirus the Bonewalker"
          }
        ]
      }
    ]
  }
}
```


### Do any quests require me to kill emerald leaf spiderlings?

TBD! :)


