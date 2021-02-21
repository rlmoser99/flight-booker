# frozen_string_literal: true

class FlightsController < ApplicationController
  def index
    @airport_options = Airport.all.map { |u| [u.location, u.id] }
    return if search_params.empty?

    @booking_options = find_booking_options
  end

  private

    def search_params
      params.permit(:origin_id, :destination_id, :departure_date)
    end

    def find_booking_options
      if params[:origin_id] == params[:destination_id]
        flash.now[:alert] = "Please choose two different origin and destination locations!"
        render :index
      else
        BookingOptions.new(search_params).find_flights
      end
    end
end
