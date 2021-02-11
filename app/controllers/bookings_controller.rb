class BookingsController < ApplicationController
  def new
    @flight = params[:flight_id]
    @available_flights = Flight.where(flight_params).order(departure_time: :asc) unless flight_params.empty?
  end

  private

    def flight_params
      params.permit(:origin_id, :destination_id, :departure_date)
    end
end
