# frozen_string_literal: true

# == Schema Information
#
# Table name: seats
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  booking_id :bigint
#  flight_id  :bigint
#
class Seat < ApplicationRecord
  belongs_to :flight
  belongs_to :booking
end
