# frozen_string_literal: true

class FlightsController < ApplicationController
  def index
    @airport_options = Airport.all.map { |u| [u.location, u.id] }

    @available_flights = Flight.where(flight_params).order(departure_time: :asc) unless flight_params.empty?
  end

  private

    def flight_params
      params.permit(:origin_id, :destination_id, :departure_date)
    end
end
