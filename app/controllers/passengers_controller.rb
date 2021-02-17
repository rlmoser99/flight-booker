class PassengersController < ApplicationController
  def new
    @passenger = Passenger.new
  end

  def create
    @passenger = Passenger.new(passenger_params)

    if @passenger.save
      redirect_to @passenger
    else
      render "new"
    end
  end

  def show
    @passenger = Passenger.find(params[:id])
  end

  private

    def passenger_params
      params.require(:passenger).permit(:name, :email)
    end
end
