# frozen_string_literal: true

# == Schema Information
#
# Table name: bookings
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  flight_id    :bigint
#  passenger_id :bigint
#
class Booking < ApplicationRecord
  has_many :passengers, dependent: :destroy
  has_many :seats, dependent: :destroy
  has_many :flights, through: :seats

  accepts_nested_attributes_for :passengers
end
