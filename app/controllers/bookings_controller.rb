# frozen_string_literal: true

class BookingsController < ApplicationController
  def new
    @flight = Flight.find_by(id: params[:flight_id])
    @connecting_flights = FlightConnections.new({ "origin_id" => @flight.origin_id,
                                                  "destination_id" => @flight.destination_id,
                                                  "departure_date" => @flight.departure_date }).find_connections
    @booking = Booking.new(flight: @flight)
    number = params[:number].to_i
    number.times { @booking.passengers.build }
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
end
