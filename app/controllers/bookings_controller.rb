# frozen_string_literal: true

class BookingsController < ApplicationController
  def new
    @booking = Booking.new
    @passenger_count = params[:passenger_count].to_i
    @flights = find_flights(params[:booking_option])
    @passenger_count.times { @booking.tickets.build }
    # booking.passengers.distinct.count
    # @passenger_count.times { @flights.each { |flight| @booking.ticket.build(flight: flight) } }
  end

  def create
    @booking = Booking.new
    # Need to figure out how to create all these things - keeping things in params!!!
    # @flights = find_flights(params[:booking][:booking_option])
    # @passengers_info = params[:booking][:passengers]
    # @passengers_info.each do |info|
    #   passenger = Passenger.new(name: info[:name], email: info[:email])
    #   @flights.each { |flight| @booking.tickets.build(flight: flight, passenger: passenger) }
    # end

    if @booking.save
      redirect_to booking_path
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

    def search_params
      params.permit(:origin_id, :destination_id, :departure_date)
    end

  # def find_flights(params)
  #   flight_numbers = params.split
  #   flight_numbers.collect { |num| Flight.find_by(id: num) }
  # end
end
