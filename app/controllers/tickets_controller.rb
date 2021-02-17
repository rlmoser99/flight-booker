class TicketsController < ApplicationController
  def new
    @ticket = Ticket.new
    # @flight_numbers = params[:booking_option].split
    # @booking_count = params[:passenger_count]
  end

  def create
    # @booking_flights = find_flights
  end

  private

    def tickets_params
      params.require(:ticket).permit(:passenger_count, :booking_option, passengers_attributes: %i[name email])
    end
end
