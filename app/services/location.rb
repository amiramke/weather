class Location
  attr_reader :geocoder

  def initialize(input)
    @geocoder = Geocoder.search(input)
  end

  def coordinates
    geocoder.first&.coordinates
  end

  def postal_code
    geocoder.first&.postal_code
  end
end
