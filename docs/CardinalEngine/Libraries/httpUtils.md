# HttpUtils

!!! info
    Documentation for this page is a work in progress.

| HTTP Method   | Request has body  | Response has body | Safe              | Idempotent        | Cacheable         |
| :           : | :               : | :               : | :               : | :               : | :               : |
| GET           | :material-close:  | :material-check:  | :material-check:  | :material-check:  | :material-check:  |
| HEAD          | :material-close:  | :material-close:  | :material-check:  | :material-check:  | :material-check:  |
| POST          | :material-check:  | :material-check:  | :material-close:  | :material-close:  | :material-check:  |
| PUT           | :material-check:  | :material-check:  | :material-close:  | :material-check:  | :material-close:  |
| DELETE        | :material-check:  | :material-check:  | :material-close:  | :material-check:  | :material-close:  |
| TRACE         | :material-close:  | :material-check:  | :material-check:  | :material-check:  | :material-close:  |
| OPTIONS       | :material-close:  | :material-check:  | :material-check:  | :material-check:  | :material-close:  |
| CONNECT       | :material-close:  | :material-check:  | :material-close:  | :material-close:  | :material-close:  |
| PATCH         | :material-check:  | :material-check:  | :material-close:  | :material-close:  | :material-close:  |

## get

```lua
HttpUtils.get(url, headers?)
```

## head

```lua
HttpUtils.head(url, headers?, body?)
```

## post

```lua
HttpUtils.post(url, headers?, body?)
```

## put

```lua
HttpUtils.put(url, headers?, body?)
```

## delete

```lua
HttpUtils.delete(url, headers?, body?)
```

## connect

```lua
HttpUtils.connect(url, headers?)
```

## options

```lua
HttpUtils.options(url, headers?)
```

## trace

```lua
HttpUtils.trace(url, headers?)
```

## patch

```lua
HttpUtils.patch(url, headers?, body?)
```

## formatQueryStrings