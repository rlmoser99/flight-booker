# frozen_string_literal: true

# == Schema Information
#
# Table name: flights
#
#  id             :bigint           not null, primary key
#  departure_date :date
#  departure_time :time
#  duration       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  destination_id :bigint
#  origin_id      :bigint
#
FactoryBot.define do
  factory :flight do
    origin_id { "" }
    destination_id { "" }
    departure_date { "2021-02-08" }
    departure_time { "2021-02-08 17:08:15" }
    duration { 1 }
  end
end
