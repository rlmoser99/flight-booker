# frozen_string_literal: true

class FlightsController < ApplicationController
  def index
    @airport_options = Airport.all.map { |u| [u.location, u.id] }
    return if search_params.empty?

    @available_flights = Flight.where(search_params)
    @connecting_flights = FlightConnections.new(search_params).find_connections
  end

  private

    def search_params
      params.permit(:origin_id, :destination_id, :departure_date)
    end

    # Will need to set up & use strong params
    def flight_params
      params.require(:flight).permit(:origin_id, :destination_id, :number, :departure_date, :flight_id)
    end
end
