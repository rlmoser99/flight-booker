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
#
class Passenger < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_many :flights, through: :bookings
end
