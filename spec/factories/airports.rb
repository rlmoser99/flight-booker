# frozen_string_literal: true

# == Schema Information
#
# Table name: airports
#
#  id         :bigint           not null, primary key
#  code       :string
#  location   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :airport do
    code { "TOP" }
    location { "Springfield, US" }

    trait :new_york_city do
      code { "NYC" }
    end

    trait :san_francisco do
      code { "SFO" }
    end

    trait :los_angeles do
      code { "LAX" }
    end

    trait :atlanta do
      code { "ATL" }
    end

    trait :chicago do
      code { "ORD" }
    end
  end
end
