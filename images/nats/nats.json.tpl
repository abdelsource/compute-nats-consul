{
  "service": {
    "name": "nats",
    "tags": ["$zone"],
    "port": 4222,
    "check": {
      "id": "nats",
      "name": "HTTP on port 8222",
      "http": "http://localhost:8222/varz",
      "interval": "10s",
      "timeout": "1s"
    }
  }
}

