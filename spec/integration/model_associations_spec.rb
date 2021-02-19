# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "model associations" do
  # Airports
  let!(:san_fran) { create(:airport) }
  let!(:chicago) { create(:airport) }
  let!(:new_york) { create(:airport) }

  # Flights
  let!(:san_fran_to_chicago) do
    create(:flight, origin_airport: san_fran, destination_airport: chicago)
  end
  let!(:chicago_to_new_york) do
    create(:flight, origin_airport: chicago, destination_airport: new_york)
  end

  # Bookings
  let!(:anna_amy_booking) { create(:booking) }
  let!(:joe_booking) { create(:booking) }

  # Passengers
  let!(:anna) { create(:passenger, booking: anna_amy_booking) }
  let!(:amy) { create(:passenger, booking: anna_amy_booking) }
  let!(:joe) { create(:passenger, booking: joe_booking) }

  # Seats
  let!(:anna_chicago_seat) { create(:seat, booking: anna_amy_booking, flight: san_fran_to_chicago) }
  let!(:anna_new_york_seat) { create(:seat, booking: anna_amy_booking, flight: chicago_to_new_york) }
  let!(:amy_chicago_seat) { create(:seat, booking: anna_amy_booking, flight: san_fran_to_chicago) }
  let!(:amy_new_york_seat) { create(:seat, booking: anna_amy_booking, flight: chicago_to_new_york) }
  let!(:joe_chicago_seat) { create(:seat, booking: joe_booking, flight: san_fran_to_chicago) }

  context 'airport' do
    it "includes correct departing flights" do
      expect(san_fran.departing_flights).to include(san_fran_to_chicago)
      expect(chicago.departing_flights).to include(chicago_to_new_york)
    end

    it "includes correct arriving flights" do
      expect(chicago.arriving_flights).to include(san_fran_to_chicago)
      expect(new_york.arriving_flights).to include(chicago_to_new_york)
    end
  end

  context 'passenger' do
    it "includes correct flights" do
      expect(anna.flights).to include(san_fran_to_chicago, chicago_to_new_york)
      expect(amy.flights).to include(san_fran_to_chicago, chicago_to_new_york)
      expect(joe.flights).to include(san_fran_to_chicago)
    end

    it "includes correct booking" do
      expect(anna.booking).to eq(anna_amy_booking)
      expect(amy.booking).to eq(anna_amy_booking)
      expect(joe.booking).to eq(joe_booking)
      expect(joe.booking).not_to eq(anna_amy_booking)
    end
  end

  context "booking" do
    it "includes correct passengers" do
      expect(anna_amy_booking.passengers).to include(anna, amy)
      expect(anna_amy_booking.passengers).not_to include(joe)
      expect(joe_booking.passengers).to include(joe)
    end

    it "includes correct flights" do
      expect(anna_amy_booking.flights).to include(san_fran_to_chicago, chicago_to_new_york)
      expect(joe_booking.flights).to include(san_fran_to_chicago)
      expect(joe_booking.flights).not_to include(chicago_to_new_york)
    end

    it "knows passenger count" do
      expect(anna_amy_booking.passengers.count).to eq(2)
      expect(joe_booking.passengers.count).to eq(1)
    end

    it "includes correct seats" do
      expect(anna_amy_booking.seats).to include(anna_chicago_seat, anna_new_york_seat, amy_chicago_seat,
                                                amy_new_york_seat)
      expect(joe_booking.seats).to include(joe_chicago_seat)
      expect(joe_booking.seats).not_to include(anna_chicago_seat, anna_new_york_seat, amy_chicago_seat,
                                               amy_new_york_seat)
    end

    it "knows seat count" do
      expect(anna_amy_booking.seats.count).to eq(4)
      expect(joe_booking.seats.count).to eq(1)
    end
  end

  context "flight" do
    it "includes correct seats" do
      expect(san_fran_to_chicago.seats).to include(amy_chicago_seat, amy_chicago_seat, joe_chicago_seat)
      expect(chicago_to_new_york.seats).to include(amy_new_york_seat, anna_new_york_seat)
      expect(chicago_to_new_york.seats).not_to include(joe_chicago_seat)
    end

    it "includes correct passengers" do
      expect(san_fran_to_chicago.passengers).to include(anna, amy, joe)
      expect(chicago_to_new_york.passengers).to include(anna, amy)
      expect(chicago_to_new_york.passengers).not_to include(joe)
    end

    it "includes correct bookings" do
      expect(san_fran_to_chicago.bookings).to include(anna_amy_booking, joe_booking)
      expect(chicago_to_new_york.bookings).to include(anna_amy_booking)
      expect(chicago_to_new_york.bookings).not_to include(joe_booking)
    end
  end

  context "seat" do
    it "have the correct flight" do
      expect(anna_chicago_seat.flight).to eq(san_fran_to_chicago)
      expect(anna_new_york_seat.flight).to eq(chicago_to_new_york)
      expect(amy_chicago_seat.flight).to eq(san_fran_to_chicago)
      expect(amy_new_york_seat.flight).to eq(chicago_to_new_york)
      expect(joe_chicago_seat.flight).to eq(san_fran_to_chicago)
      expect(joe_chicago_seat.flight).not_to eq(chicago_to_new_york)
    end

    it "have the correct booking" do
      expect(anna_chicago_seat.booking).to eq(anna_amy_booking)
      expect(anna_new_york_seat.booking).to eq(anna_amy_booking)
      expect(amy_chicago_seat.booking).to eq(anna_amy_booking)
      expect(amy_new_york_seat.booking).to eq(anna_amy_booking)
      expect(joe_chicago_seat.booking).to eq(joe_booking)
      expect(joe_chicago_seat.booking).not_to eq(anna_amy_booking)
    end
  end
end
