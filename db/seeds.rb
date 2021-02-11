# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

def morning_time
  Faker::Time.between_dates(from: Date.today - 1, to: Date.today, period: :morning)
end

def afternoon_time
  Faker::Time.between_dates(from: Date.today - 1, to: Date.today, period: :afternoon)
end

def evening_time
  Faker::Time.between_dates(from: Date.today - 1, to: Date.today, period: :evening)
end

def random_duration
  rand(75..175)
end

airports = [
  Airport.create!(code: "SFO", location: "San Francisco, CA"),
  Airport.create!(code: "NYC", location: "New York City, NY"),
  Airport.create!(code: "ATL", location: "Atlanta, GA"),
  Airport.create!(code: "ORD", location: "Chicago, IL"),
  Airport.create!(code: "LAX", location: "Los Angeles, CA"),
  Airport.create!(code: "DFW", location: "Dallas, TX"),
  Airport.create!(code: "MCO", location: "Orlando, FL"),
  Airport.create!(code: "DEN", location: "Denver, CO")
]

airport_pairs = airports.permutation(2)
start = Time.zone.today
finish = Time.zone.today + 1.week

(start..finish).each do |date|
  airport_pairs.each do |airport_pair|
    flight_duration = random_duration

    Flight.create!(origin_airport: airport_pair[0],
                   destination_airport: airport_pair[1],
                   departure_date: date,
                   departure_time: morning_time,
                   duration: flight_duration + 5)

    Flight.create!(origin_airport: airport_pair[0],
                   destination_airport: airport_pair[1],
                   departure_date: date,
                   departure_time: afternoon_time,
                   duration: flight_duration)

    Flight.create!(origin_airport: airport_pair[0],
                   destination_airport: airport_pair[1],
                   departure_date: date,
                   departure_time: evening_time,
                   duration: flight_duration - 7)
  end
end

passengers = [
  Passenger.create!(name: "Amelia Earhart", email: "amelia@earhart.com"),
  Passenger.create!(name: "Maude Bonney", email: "maude@bonney.com")
]

Booking.create!(flight: Flight.first, passenger: passengers[0])
Booking.create!(flight: Flight.last, passenger: passengers[1])
