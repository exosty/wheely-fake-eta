## Usage

#### `Setup`

Git clone this repo and then run:
```bash
$ ./script/setup
```

#### `Running tests`

```bash
$ ./script/test
```

#### `Running server`

```bash
$ ./script/server *port (default: 9292)
```

#### `Doc`

[http://localhost:port/doc](http://localhost:9292/doc)

#### `Making request`

```bash
curl 'http://localhost:9292/v1/eta?lat=50&lng=60&limit=4'

# 1234
```
