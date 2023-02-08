class WeatherApi
  def initialize(url, adapter)
    @url = url
    @adapter = adapter
  end

  def fetch_data
    uri = URI(@url)
    Net::HTTP.get(uri)
  end

  def results(postal_code) # filtering params can also be added
    @adapter.output(self, postal_code) # can pass params here
  end
end
