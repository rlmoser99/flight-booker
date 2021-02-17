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
FactoryBot.define do
  factory :seat do
    booking_id { "" }
    flight_id { "" }
  end
end
