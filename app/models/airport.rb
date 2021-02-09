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
class Airport < ApplicationRecord
  has_many :arriving_flights, class_name: "Flight",
                              foreign_key: "destination_id",
                              dependent: :destroy,
                              inverse_of: :destination_airport
  has_many :departing_flights, class_name: "Flight",
                               foreign_key: "origin_id",
                               dependent: :destroy,
                               inverse_of: :origin_airport
end
