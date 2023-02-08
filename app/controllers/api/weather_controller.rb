class Api::WeatherController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    if params[:address].blank?
      render json: { error: 'Address cannot be blank.' }, status: :bad_request
      return
    end

    location = Location.new(params[:address])
    coordinates = location.coordinates

    if coordinates.nil?
      render json: { error: 'Could not find location.' }, status: :bad_request
      return
    end

    lat = coordinates[0]
    lon = coordinates[1]

    postal_code = location.postal_code # to be used for caching

    adapter = OpenMeteo.new # adapter design pattern. Can easily switch to another weather provider

    begin
      api = WeatherApi.new(adapter.url(lat, lon), adapter)
    rescue => e
      render json: { error: e.message }, status: :bad_request
      return
    end

    render json: api.results(postal_code), status: :ok
  end
end
