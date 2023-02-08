class OpenMeteo
  def initialize(key = nil)
    @key = key # not required for the free tier of this API vendor, but others will need it
  end

  def url(latitude, longitude)
    "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset&current_weather=true&temperature_unit=fahrenheit&windspeed_unit=mph&precipitation_unit=inch&timezone=auto"
  end

  def output(context, postal_code) # can add more parameters here for filtering response data, etc.
    cache_hit = true

    data =
      if postal_code
        result = Rails.cache.fetch("weather_results_#{postal_code}", expires_in: 30.minutes) do
          cache_hit = false
          context.fetch_data
        end
      else
        cache_hit = false
        context.fetch_data
      end

    current_weather = JSON.parse(data)["current_weather"]
    daily_forecast = JSON.parse(data)["daily"]

    dates = daily_forecast["time"]
    min_temps = daily_forecast["temperature_2m_min"]
    max_temps = daily_forecast["temperature_2m_max"]

    weekly_forecast = dates.zip(min_temps, max_temps).to_h { |(k, v1, v2)| [k, [v1, v2]] }

    current_weather
      .merge({ "weekly_forecast" => weekly_forecast })
      .merge({ "cache_hit" => (cache_hit ? 'true' : 'false') })
  end
end
