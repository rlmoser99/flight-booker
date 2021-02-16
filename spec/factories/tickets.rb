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
FactoryBot.define do
  factory :ticket do
    booking_id { "" }
    passenger_id { "" }
    flight_id { "" }
  end
end
