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
class Flight < ApplicationRecord
  belongs_to :origin_airport, class_name: "Airport",
                              foreign_key: :origin_id,
                              inverse_of: :departing_flights
  belongs_to :destination_airport, class_name: "Airport",
                                   foreign_key: :destination_id,
                                   inverse_of: :arriving_flights
  has_many :seats, dependent: :destroy
  has_many :bookings, through: :seats
  has_many :passengers, through: :bookings

  # REMOVE DUPLICATE INFO HERE
  def details
    depart = departure_time.strftime('%l:%M %p')
    arrive = (departure_time + (duration.to_f / 60).hours).strftime('%l:%M %p')
    "#{depart} departure from #{origin_airport.code} and arrive at #{arrive} to #{destination_airport.code}"
  end

  def humanize_arrival
    (departure_time + (duration.to_f / 60).hours).strftime('%l:%M %p')
  end

  def estimated_departure_time
    departure_time.strftime('%l:%M %p')
  end

  def humanize_date
    departure_date.strftime("%B %d, %Y")
  end
end
