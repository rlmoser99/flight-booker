# frozen_string_literal: true

require "rails_helper"

RSpec.describe FlightGenerator do
  let(:tomorrow) { Time.zone.tomorrow }
  subject(:flight_generator) { described_class.new(tomorrow) }

  Airport.find_or_create_by(code: "SFO", location: "San Francisco, CA")
  Airport.find_or_create_by(code: "NYC", location: "New York City, NY")
  Airport.find_or_create_by(code: "ATL", location: "Atlanta, GA")
  Airport.find_or_create_by(code: "ORD", location: "Chicago, IL")
  Airport.find_or_create_by(code: "LAX", location: "Los Angeles, CA")
  Airport.find_or_create_by(code: "DFW", location: "Dallas, TX")
  Airport.find_or_create_by(code: "MCO", location: "Orlando, FL")
  Airport.find_or_create_by(code: "DEN", location: "Denver, CO")

  describe "#create_flights" do
    it "returns flight duration" do
      airport_pairs = 56
      flights_per_day = 3
      daily_flight_count = airport_pairs * flights_per_day
      expect { flight_generator.call }.to change(Flight, :count).by(daily_flight_count)
    end
  end
end
