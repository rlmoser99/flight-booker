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
  belongs_to :booking
  has_many :flights, through: :booking

  validates :name, presence: true
  validates :email, presence: true
end
