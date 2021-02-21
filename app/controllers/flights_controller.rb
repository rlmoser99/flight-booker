# frozen_string_literal: true

class FlightsController < ApplicationController
  def index
    @airport_options = Airport.all.map { |u| [u.location, u.id] }
    return if search_params.empty?

    @booking_options = BookingOptions.new(search_params).find_flights
  end

  private

    def search_params
      params.permit(:origin_id, :destination_id, :departure_date)
    end
end
