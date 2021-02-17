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
  has_many :tickets, dependent: :destroy
  has_many :passengers, through: :tickets
  has_many :flights, through: :tickets

  accepts_nested_attributes_for :tickets
end
