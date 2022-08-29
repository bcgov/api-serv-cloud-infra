# Load Testing

## Installation

```bash
pip install locust
```

## Run Load Test

```bash
locust --config ./locust.conf
```

## Terminology

- `spawn-rate`: Number of users to be created every second until the total number of users to simulate is fulfilled
- hatch rate is `users spawned/second`

## Reference

- https://docs.locust.io/en/stable/index.html