# frozen_string_literal: true

require "rails_helper"

RSpec.describe "add booking", type: :system do
  let!(:chicago) { create(:airport, :chicago, location: "Chicago, IL") }
  let!(:new_york) { create(:airport, :new_york_city, location: "New York City, NY") }
  let!(:atlanta) { create(:airport, :atlanta) }

  let!(:ORD_NYC) { create(:tomorrow_morning_flight, id: 1, origin_airport: chicago, destination_airport: new_york) }
  let!(:ORD_ATL) { create(:tomorrow_morning_flight, id: 2, origin_airport: chicago, destination_airport: atlanta) }

  it "allows a user to search flights, select a booking option, and create a booking" do
    visit "/"
    select("Chicago, IL", from: "origin_id")
    select("New York City, NY", from: "destination_id")
    select(2, from: "passenger_count")
    fill_in("departure_date", with: Time.zone.tomorrow)
    click_on("Find Flights")
    within(".flight-results") do
      expect(page).to have_content("Available Flights")
      expect(page).to have_content("NYC")
      expect(page).not_to have_content("ATL")
    end
    choose 'booking_option_1'
    click_on("Book Flight")
    fill_in("booking_passengers_attributes_0_name", with: "Example One")
    fill_in("booking_passengers_attributes_0_email", with: "one@example.com")
    fill_in("booking_passengers_attributes_1_name", with: "Example Two")
    fill_in("booking_passengers_attributes_1_email", with: "two@example.com")
    click_on("Finalize Booking")
    within(".content-container") do
      expect(page).to have_content("Example One")
      expect(page).to have_content("Example Two")
      expect(page).to have_content("NYC")
      expect(page).not_to have_content("ATL")
    end
  end
end
