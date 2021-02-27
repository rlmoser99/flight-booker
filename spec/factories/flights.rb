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

    trait :tomorrow do
      departure_date { Time.zone.tomorrow }
    end

    trait :long do
      duration { 300 }
    end

    trait :short do
      duration { 120 }
    end

    trait :morning do
      departure_time { Time.zone.parse("08:00 AM") }
    end

    trait :mid_morning do
      departure_time { Time.zone.parse("10:00 AM") }
    end

    trait :night do
      departure_time { Time.zone.parse("08:00 PM") }
    end

    factory :tomorrow_morning_flight, traits: %i[tomorrow morning]
    factory :tomorrow_layover_flight, traits: %i[tomorrow mid_morning]
    factory :tomorrow_night_flight, traits: %i[tomorrow night]
    factory :tomorrow_morning_short_flight, traits: %i[tomorrow morning short]
    factory :tomorrow_morning_long_flight, traits: %i[tomorrow morning long]
    factory :tomorrow_night_short_flight, traits: %i[tomorrow night short]
    factory :tomorrow_night_long_flight, traits: %i[tomorrow night long]
  end
end
