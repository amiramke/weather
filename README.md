# README

How to get the application up and running:

ruby version 3.1.3
rails version 7.0.4

Getting started:
rails assets:precompile
rails s

Open browser at http://localhost:3000/

Curl example:

```curl
curl -v -X POST "localhost:3000/api/weather" -H 'Content-Type: application/json' -d '{"address":"415 kearny st san francisco ca 94133"}'

=>

{"temperature":43.6,"windspeed":5.2,"winddirection":18.0,"weathercode":0,"time":"2023-02-08T02:00","weekly_forecast":{"2023-02-08":[43.2,58.6],"2023-02-09":[45.9,60.4],"2023-02-10":[45.9,54.7],"2023-02-11":[45.5,53.3],"2023-02-12":[43.7,62.0],"2023-02-13":[47.1,59.9],"2023-02-14":[43.2,55.7]},"cache_hit":"false"}%
```

This app is using https://api.open-meteo.com for weather data. The design pattern it's using is the adapter pattern. this allows to easily use a different weather provider

This app is using the geocoder gem to determine the lat/long of an address. The logic is encapsolated in a service so only one file has to be modified if moving to a different gem/library.

The app is caching by zipcode if it exists (30 minutes). Otherwise it calls the external API

example screenshot of the web app:
<img width="744" alt="Screen Shot 2023-02-08 at 1 54 17 AM" src="https://user-images.githubusercontent.com/1093611/217498244-87db1e7c-dd05-4478-a7bb-1bc60ba98aed.png">
