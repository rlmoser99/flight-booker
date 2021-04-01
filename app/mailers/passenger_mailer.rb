class PassengerMailer < ApplicationMailer

  def thank_you_email
    @user = params[:user]
    @booking = params[:booking]
    mail to: @booking.passengers.pluck(:email), subject: "Your booking is confirmed"
  end
end
