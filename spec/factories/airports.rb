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

    trait :east_coast do
      code { "NYC" }
    end

    trait :north_california do
      code { "SFO" }
    end

    trait :south_california do
      code { "LAX" }
    end

    trait :atlanta_layover do
      code { "ATL" }
    end

    trait :chicago_layover do
      code { "ORD" }
    end
  end
end
