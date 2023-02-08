# README

How to get the application up and running:

ruby version 3.1.3
rails version 7.0.4

Getting started:
rails s

Open browser at http://localhost:3000/

Curl example:

```curl
curl -v -X POST "localhost:3000/api/weather" -H 'Content-Type: application/json' -d '{"address":"415 kearny st san francisco ca 94133"}'
```

This app is using https://api.open-meteo.com for weather data. The design pattern it's using is the adapter pattern. this allows to easily use a different weather provider

This app is using the geocoder gem to determine the lat/long of an address. The logic is encapsolated in a service so only one file has to be modified if moving to a different gem/library.
