# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

Airport.find_or_create_by(code: "SFO", location: "San Francisco, CA")
Airport.find_or_create_by(code: "NYC", location: "New York City, NY")
Airport.find_or_create_by(code: "ATL", location: "Atlanta, GA")
Airport.find_or_create_by(code: "ORD", location: "Chicago, IL")
Airport.find_or_create_by(code: "LAX", location: "Los Angeles, CA")
Airport.find_or_create_by(code: "DFW", location: "Dallas, TX")
Airport.find_or_create_by(code: "MCO", location: "Orlando, FL")
Airport.find_or_create_by(code: "DEN", location: "Denver, CO")

start = Time.zone.today
finish = Time.zone.today + 31.days

(start..finish).each do |date|
  flight_generator = FlightGenerator.new(date)
  flight_generator.call
end
