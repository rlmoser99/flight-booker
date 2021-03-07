# frozen_string_literal: true

namespace :data_maintenance do
  desc "Generates flights to keep database current"
  task generate_flights: :environment do
    future_date = Time.zone.today + 31.days
    flight_generator = FlightGenerator.new(future_date)
    flight_generator.call
  end
  desc "Destroy pasts flights to keep database managable"
  task destroy_past_flights: :environment do
    yesterday = Time.zone.today - 1.day
    past_flights = Flight.where('departure_date < ?', yesterday)
    past_flights.destroy_all
  end
end
