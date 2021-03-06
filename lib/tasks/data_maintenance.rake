# frozen_string_literal: true

namespace :data_maintenance do
  desc "Generates flights to keep database current"
  task generate_flights: :environment do
    future_date = Time.zone.today + 62.days
    flight_generator = FlightGenerator.new(future_date)
    flight_generator.call
  end
end
