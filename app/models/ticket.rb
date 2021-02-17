# == Schema Information
#
# Table name: tickets
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  booking_id   :bigint
#  flight_id    :bigint
#  passenger_id :bigint
#
class Ticket < ApplicationRecord
  belongs_to :booking
  belongs_to :passenger
  belongs_to :flight

  accepts_nested_attributes_for :passenger
end
