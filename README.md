# README

Base URL for now is http://yrk.cae.me.uk:3000 - this will change eventually.


## Admin Dashboard

See /admin for a quick and dirty display to see what's in db and edit things in a UI.


## API

Simple REST API at /api/v1/

Currently implemented resources are items, monsters, npcs, quest_objectives, quests, zones.

stats don't have a controller, use nested attributes (example below). Considering removing quest_objectives controller but we'll see how it goes.

No auth yet, this will change :)

### Get all Zones (or any resource)

```
curl http://localhost:3000/api/v1/zones
```

```json
[{"id":1,"name":"Thronefast"},{"id":2,"name":"Avendyr's Pass"}]
```

### Get Single Zone

```
curl http://localhost:3000/api/v1/zones/1
```

```json
{"id":1,"name":"Thronefast"}
```

Most associated resources just return the id/name for now to keep it simple, ie on a monster, you get:

```json
{
    "id": 1,
    "elite": true,
    "level": 13,
    "name": "Zirus the Bonewalker",
    "named": true,
    "zone": {
        "id": 1,
        "name": "Thronefast"
    }
}
```

The exceptions are the nested attributes mentioned above, so if an item has stats (remember stats are their own resource), you get full details since I think you'll probably always need them.

```json
{
    "id": 1,
    "category": "weapon",
    "classes": [],
    "created_at": "2024-02-08 08:20:59 UTC",
    "monster": {
        "id": 1,
        "name": "Zirus the Bonewalker"
    },
    "name": "Gnossa's Walking Stick",
    "no_trade": false,
    "quest": null,
    "slot": null,
    "soulbound": false,
    "stats": [
        {
            "id": 1,
            "amount": 5,
            "item": {
                "id": 1,
                "name": "Gnossa's Walking Stick"
            },
            "stat": "endurance"
        }
    ],
    "updated_at": "2024-02-08 08:20:59 UTC",
    "vendor_copper": null,
    "weight": "0.5"
}
```

I can add more nesting but the more there is, the slower the API gets, and we run into the risk of circular dependencies, it gets messy.


### Create

```
curl -d '{"name": "Silent Plains"}' -H "Content-Type: application/json" -X POST http://localhost:3000/api/v1/zones
```

```json
{"id":4,"name":"Silent Plains"}
```

### Update

```
curl -d '{"zone_id": 2, "name":"Zirus the Bonewalker"}' -H "Content-Type: application/json" -X PUT http://localhost:3000/api/v1/monsters/1
```

Success returns the updated object as JSON:

```json
{"id":1,"elite":true,"level":13,"name":"Zirus the Bonewalker","named":true,"zone":{"id":1,"name":"Thronefast"}}
```

### Many-to-many Assignments

Some relations are many-to-many, for example items to monsters (an item can be dropped by several different monsters; and monsters can drop several different items).

So these have a special assign/unassign in order to manage that relationship.

Assignment:

```
curl -d '{"monster_id":1}' -H "Content-Type: application/json" -X POST http://localhost:3000/api/v1/items/2/assign
```

So after this, monster_id=1 is linked to item_id 2 (ie, it can drop it)

Unassignment:
```
curl -d '{"monster_id":1}' -H "Content-Type: application/json" -X POST http://localhost:3000/api/v1/items/2/unassign
```

After this, the link is broken again and monster_id=1 is no longer dropping item_id=2.

These return HTTP 201 on success.


### Errors

Errors for create/update give you an errors hash formatted like this:

```json
{"errors":{"name":["has already been taken"]}}
```

### Nested Attributes (WIP)

Supported nested attributes are currently:

* `stats` on an `item`
* `quest_objectives` on a `quest`

Creating a nested attribute example:

```
curl -d '{"stats_attributes": [{"stat": "endurance", "amount": 4}]}' -H "Content-Type: application/json" -X PUT http://localhost:3000/api/v1/items/1
```

Supply the existing id to update an existing stat:

```
curl -d '{"stats_attributes": [{"id":3, "stat": "endurance", "amount": 6}]}' -H "Content-Type: application/json" -X PUT http://localhost:3000/api/v1/items/1
```

Destroying nested attributes TBD.


### Delete

Not active yet
