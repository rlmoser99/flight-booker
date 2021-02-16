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

  # Passengers
  let!(:anna) { create(:passenger) }
  let!(:amy) { create(:passenger) }
  let!(:joe) { create(:passenger) }

  # Booking
  let!(:anna_amy_booking) { create(:booking) }
  let!(:joe_booking) { create(:booking) }

  # Tickets
  let!(:anna_chicago_ticket) do
    create(:ticket, booking: anna_amy_booking, passenger: anna, flight: san_fran_to_chicago)
  end
  let!(:anna_new_york_ticket) do
    create(:ticket, booking: anna_amy_booking, passenger: anna, flight: chicago_to_new_york)
  end
  let!(:amy_chicago_ticket) { create(:ticket, booking: anna_amy_booking, passenger: amy, flight: san_fran_to_chicago) }
  let!(:amy_new_york_ticket) { create(:ticket, booking: anna_amy_booking, passenger: amy, flight: chicago_to_new_york) }
  let!(:joe_chicago_ticket) { create(:ticket, booking: joe_booking, passenger: joe, flight: san_fran_to_chicago) }

  context 'airports' do
    it "include correct departing flights" do
      expect(san_fran.departing_flights).to include(san_fran_to_chicago)
      expect(chicago.departing_flights).to include(chicago_to_new_york)
    end

    it "include correct arriving flights" do
      expect(chicago.arriving_flights).to include(san_fran_to_chicago)
      expect(new_york.arriving_flights).to include(chicago_to_new_york)
    end
  end

  context 'passengers' do
    it "includes correct flights" do
      expect(anna.flights).to include(san_fran_to_chicago, chicago_to_new_york)
      expect(amy.flights).to include(san_fran_to_chicago, chicago_to_new_york)
      expect(joe.flights).to include(san_fran_to_chicago)
    end

    it "includes correct tickets" do
      expect(anna.tickets).to include(anna_chicago_ticket, anna_new_york_ticket)
      expect(amy.tickets).to include(amy_chicago_ticket, amy_new_york_ticket)
      expect(joe.tickets).to include(joe_chicago_ticket)
      expect(joe.tickets).not_to include(amy_chicago_ticket)
    end

    it "includes correct booking" do
      expect(anna.bookings).to include(anna_amy_booking)
      expect(amy.bookings).to include(anna_amy_booking)
      expect(joe.bookings).to include(joe_booking)
      expect(joe.bookings).not_to include(anna_amy_booking)
    end
  end

  context "bookings" do
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

    it "includes correct tickets" do
      expect(anna_amy_booking.tickets).to include(anna_chicago_ticket, anna_new_york_ticket, amy_chicago_ticket,
                                                  amy_new_york_ticket)
      expect(joe_booking.tickets).to include(joe_chicago_ticket)
      expect(joe_booking.tickets).not_to include(anna_chicago_ticket, anna_new_york_ticket, amy_chicago_ticket,
                                                 amy_new_york_ticket)
    end
  end

  context "flights" do
    it "includes correct tickets" do
      expect(san_fran_to_chicago.tickets).to include(amy_chicago_ticket, amy_chicago_ticket, joe_chicago_ticket)
      expect(chicago_to_new_york.tickets).to include(amy_new_york_ticket, anna_new_york_ticket)
      expect(chicago_to_new_york.tickets).not_to include(joe_chicago_ticket)
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

  context "tickets" do
    it "have the correct passenger" do
      expect(anna_chicago_ticket.passenger).to eq(anna)
      expect(anna_new_york_ticket.passenger).to eq(anna)
      expect(amy_chicago_ticket.passenger).to eq(amy)
      expect(amy_new_york_ticket.passenger).to eq(amy)
      expect(joe_chicago_ticket.passenger).to eq(joe)
      expect(joe_chicago_ticket.passenger).not_to eq(anna)
    end

    it "have the correct flight" do
      expect(anna_chicago_ticket.flight).to eq(san_fran_to_chicago)
      expect(anna_new_york_ticket.flight).to eq(chicago_to_new_york)
      expect(amy_chicago_ticket.flight).to eq(san_fran_to_chicago)
      expect(amy_new_york_ticket.flight).to eq(chicago_to_new_york)
      expect(joe_chicago_ticket.flight).to eq(san_fran_to_chicago)
      expect(joe_chicago_ticket.flight).not_to eq(chicago_to_new_york)
    end

    it "have the correct booking" do
      expect(anna_chicago_ticket.booking).to eq(anna_amy_booking)
      expect(anna_new_york_ticket.booking).to eq(anna_amy_booking)
      expect(amy_chicago_ticket.booking).to eq(anna_amy_booking)
      expect(amy_new_york_ticket.booking).to eq(anna_amy_booking)
      expect(joe_chicago_ticket.booking).to eq(joe_booking)
      expect(joe_chicago_ticket.booking).not_to eq(anna_amy_booking)
    end
  end
end
