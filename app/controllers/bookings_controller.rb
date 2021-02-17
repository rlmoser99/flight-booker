# frozen_string_literal: true

class BookingsController < ApplicationController
  def new
    @booking = Booking.new
    @passenger_count = params[:passenger_count].to_i
    @flights = find_flights(params[:booking_option])
    @passenger_count.times { @booking.passengers.build }
  end

  def create
    @booking = Booking.new(passenger_params)
    @flights = find_flights(params[:booking][:booking_option])
    @flights.each { |flight| @booking.seats.build(flight: flight) }

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
      params.require(:booking).permit(:flight_id,
                                      :passenger_count,
                                      :booking_option,
                                      passengers_attributes: %i[name email])
    end

    def passenger_params
      params.require(:booking).permit(passengers_attributes: %i[name email])
    end

    def find_flights(params)
      flight_numbers = params.split
      flight_numbers.collect { |num| Flight.find_by(id: num) }
    end
end
