# frozen_string_literal: true

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

def find_flight_duration(airports)
  {
    SFO: { NYC: 308, ATL: 257, ORD: 224, LAX: 53, DFW: 181, MCO: 292, DEN: 125 },
    NYC: { SFO: 308, ATL: 101, ORD: 99, LAX: 296, DFW: 173, MCO: 122, DEN: 199 },
    ATL: { SFO: 257, NYC: 101, ORD: 84, LAX: 236, DFW: 98, MCO: 61, DEN: 151 },
    ORD: { SFO: 224, NYC: 99, ATL: 84, LAX: 213, DFW: 106, MCO: 129, DEN: 116 },
    LAX: { SFO: 53, NYC: 296, ATL: 236, ORD: 213, DFW: 155, MCO: 266, DEN: 113 },
    DFW: { SFO: 181, NYC: 173, ATL: 98, ORD: 106, LAX: 155, MCO: 127, DEN: 88 },
    MCO: { SFO: 292, NYC: 122, ATL: 61, ORD: 129, LAX: 266, DFW: 127, DEN: 190 },
    DEN: { SFO: 125, NYC: 199, ATL: 151, ORD: 116, LAX: 113, DFW: 88, MCO: 190 }
  }[airports[0].to_sym][airports[1].to_sym]
end

airports = [
  Airport.find_or_create_by(code: "SFO", location: "San Francisco, CA"),
  Airport.find_or_create_by(code: "NYC", location: "New York City, NY"),
  Airport.find_or_create_by(code: "ATL", location: "Atlanta, GA"),
  Airport.find_or_create_by(code: "ORD", location: "Chicago, IL"),
  Airport.find_or_create_by(code: "LAX", location: "Los Angeles, CA"),
  Airport.find_or_create_by(code: "DFW", location: "Dallas, TX"),
  Airport.find_or_create_by(code: "MCO", location: "Orlando, FL"),
  Airport.find_or_create_by(code: "DEN", location: "Denver, CO")
]

airport_pairs = airports.permutation(2)
start = Time.zone.today
finish = Time.zone.today + 1.week

(start..finish).each do |date|
  airport_pairs.each do |airport_pair|
    flight_codes = airport_pair.map(&:code)
    flight_duration = find_flight_duration(flight_codes)

    Flight.find_or_create_by(origin_airport: airport_pair[0],
                             destination_airport: airport_pair[1],
                             departure_date: date,
                             departure_time: morning_time,
                             duration: flight_duration)

    Flight.find_or_create_by(origin_airport: airport_pair[0],
                             destination_airport: airport_pair[1],
                             departure_date: date,
                             departure_time: afternoon_time,
                             duration: flight_duration)

    Flight.find_or_create_by(origin_airport: airport_pair[0],
                             destination_airport: airport_pair[1],
                             departure_date: date,
                             departure_time: evening_time,
                             duration: flight_duration)
  end
end
