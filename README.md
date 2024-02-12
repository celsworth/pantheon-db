# README

Base URL for now is http://yrk.cae.me.uk:3000 - this will change eventually.


## Admin Dashboard

See /admin for a quick and dirty display to see what's in db and edit things in a UI.

## GraphQL

Experimental non-exhaustive GraphQL is implemented; have a play with http://yrk.cae.me.uk:3000/graphiql


## REST API

REST API is at /api/v1/

Currently implemented resources are items, monsters, npcs, quest_objectives, quests, zones.

No auth yet, this will change :)

### Search Items

Given a data.json input like this:

```json
{
  "name": "blood",
  "category": "shield",
  "class": "shaman",
  "stats": [
    {
      "stat": "armor",
      "operator": ">",
      "value": 3
    }
  ],
  "required_level": [
    {
      "operator": ">",
      "value": 5
    }
  ],
  "attrs": [
    "magic"
  ]
}
```

You can POST it with curl like this:

```
curl -H "Content-Type: application/json" -X POST -d @data.json http://yrk.cae.me.uk:3000/api/v1/items/search
```

Which will return matching items (a Blood-soaked Shield from the sample data).

You can filter on multiple stats and multiple attrs, items that match them all will be returned. Valid operators are `>`, `<`, `>=`, `<=`, `=`.

Note some are arrays so you can specify multiple filters for a parameter, like > and < for a range.

Other filters are shown in this tenuous example:

```json
{
  "dropped_by": 1,
  "reward_from_quest": 1,
  "slot": "chest",
  "weight": [
    {
      "operator": ">",
      "value": 3
    },
    {
      "operator": "<=",
      "value": 4
    }
  ]
}
```

`dropped_by` should be a monster.id to limit the search to items dropped by that monster. `reward_from_quest` should be a quest.id to show items rewarded by that quest.



### Get all Zones (or any resource)

```
curl http://yrk.cae.me.uk:3000/api/v1/zones
```

```json
[{"id":1,"name":"Thronefast"},{"id":2,"name":"Avendyr's Pass"}]
```

### Get Single Zone

```
curl http://yrk.cae.me.uk:3000/api/v1/zones/1
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


### Create

```
curl -d '{"name": "Silent Plains"}' -H "Content-Type: application/json" -X POST http://yrk.cae.me.uk:3000/api/v1/zones
```

```json
{"id":4,"name":"Silent Plains"}
```

### Update

```
curl -d '{"zone_id": 2, "name":"Zirus the Bonewalker"}' -H "Content-Type: application/json" -X PUT http://yrk.cae.me.uk:3000/api/v1/monsters/1
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
curl -d '{"monster_id":1}' -H "Content-Type: application/json" -X POST http://yrk.cae.me.uk:3000/api/v1/items/2/assign
```

So after this, monster_id=1 is linked to item_id 2 (ie, it can drop it)

Unassignment:
```
curl -d '{"monster_id":1}' -H "Content-Type: application/json" -X POST http://yrk.cae.me.uk:3000/api/v1/items/2/unassign
```

After this, the link is broken again and monster_id=1 is no longer dropping item_id=2.

These return HTTP 201 on success.


### Delete

```
curl -X DELETE http://yrk.cae.me.uk:3000/api/v1/zones/2
```

HTTP 204 (no content in response).


### Errors

Errors for create/update give you an errors hash formatted like this:

```json
{"errors":{"name":["has already been taken"]}}
```


