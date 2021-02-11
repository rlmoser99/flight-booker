# frozen_string_literal: true

class BookingsController < ApplicationController
  def new
    @available_flights = Flight.where(search_params).order(departure_time: :asc) unless search_params.empty?
    @flight_number = params[:flight_id]
    @number = params[:number]
  end

  private

    def search_params
      params.permit(:origin_id, :destination_id, :departure_date)
    end

    # Will need to set up & use strong params
    def booking_params
      params.require(:booking).permit(:flight_id, :number)
    end
end
