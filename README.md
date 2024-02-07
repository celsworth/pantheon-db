# README

## API

### Index

```
curl http://localhost:3000/zones
```
```json
[{"id":1,"name":"Thronefast","created_at":"2024-02-07T12:01:34.630Z","updated_at":"2024-02-07T12:24:34.176Z"},{"id":2,"name":"Avendyr's Pass","created_at":"2024-02-07T12:01:34.632Z","updated_at":"2024-02-07T12:01:34.632Z"}]
```

### Get Single

```
curl http://localhost:3000/zones/1
```

```json
{"zone":{"id":1,"name":"Thronefast","created_at":"2024-02-07T12:01:34.630Z","updated_at":"2024-02-07T12:24:34.176Z"}}
```

### Update

```
curl -d '{"zone_id": 2, "name":"Zirus the Bonewalker"}' -H "Content-Type: application/json" -X PUT http://localhost:3000/monsters/1
```

Success returns the new object as JSON:

```json
{"monster":{"zone_id":2,"name":"Zirus the Bonewalker","id":1,"level":4,"elite":true,"named":true,"created_at":"2024-02-07T12:01:34.640Z","updated_at":"2024-02-07T12:21:10.562Z"}}
```

Errors give you an errors hash formatted like this:

```json
{"errors":{"name":["has already been taken"]}}
```

### Delete

Not active yet
