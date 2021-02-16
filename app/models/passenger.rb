# frozen_string_literal: true

# == Schema Information
#
# Table name: passengers
#
#  id         :bigint           not null, primary key
#  email      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  booking_id :bigint
#
class Passenger < ApplicationRecord
  has_many :tickets, dependent: :destroy
  has_many :bookings, through: :tickets
  has_many :flights, through: :tickets
end
