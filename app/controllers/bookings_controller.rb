# frozen_string_literal: true

class BookingsController < ApplicationController
  def new
    @airport_options = Airport.all.map { |u| [u.location, u.id] }
    return if search_params.empty?

    @booking_options = BookingOptions.new(search_params).find_flights
  end

  def create
    @booking = Booking.new(booking_params)

    if @booking.save
      redirect_to @booking
    else
      render :new
    end
  end

  def show
    @booking = Booking.find_by(id: params[:id])
  end

  private

    def booking_params
      params.require(:booking).permit(:flight_id, passengers_attributes: %i[name email])
    end

    def search_params
      params.permit(:origin_id, :destination_id, :departure_date)
    end
end
