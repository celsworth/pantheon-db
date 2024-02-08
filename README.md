# README

## API

### Index

```
curl curl http://localhost:3000/api/v1/zones
```
```json
[{"id":1,"name":"Thronefast"},{"id":2,"name":"Avendyr's Pass"}]
```

### Get Single

```
curl http://localhost:3000/api/v1/zones/1
```

```json
"id":1,"name":"Thronefast"}
```


### Create

Soon


### Update

```
curl -d '{"zone_id": 2, "name":"Zirus the Bonewalker"}' -H "Content-Type: application/json" -X PUT http://localhost:3000/api/v1/monsters/1
```

Success returns the updated object as JSON:

```json
{"id":1,"elite":true,"level":13,"name":"Zirus the Bonewalker","named":true,"zone_id":2}
```

Errors give you an errors hash formatted like this:

```json
{"errors":{"name":["has already been taken"]}}
```

Creating a nested attribute example:

```
curl -d '{"name":"stick","stats_attributes": [{"stat":"endurance", "amount": 4}]}' -H "Content-Type: application/json" -X PUT http://localhost:3000/api/v1/items/1
```

Supply the existing id to update an existing stat

```
curl -d '{"name":"stick","stats_attributes": [{"id":3, "stat":"endurance", "amount": 6}]}' -H "Content-Type: application/json" -X PUT http://localhost:3000/api/v1/items/1
```


### Delete

Not active yet
