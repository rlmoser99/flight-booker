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

  def details
    time = departure_time.strftime('%l:%M %P')
    "#{time} - #{origin_airport.code} to #{destination_airport.code} for #{duration} minutes"
  end
end
