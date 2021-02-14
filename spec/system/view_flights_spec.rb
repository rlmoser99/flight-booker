# frozen_string_literal: true

require "rails_helper"

RSpec.describe "view available flights", type: :system do
  let(:tomorrow) { Time.zone.tomorrow }
  let!(:chicago) { create(:airport, location: "Chicago, IL", code: "ORD") }
  let!(:new_york) { create(:airport, location: "New York City, NY", code: "NYC") }
  let!(:atlanta) { create(:airport, location: "Atlanta, GA", code: "ATL") }
  let!(:chicago_to_newyork) do
    create(:flight, origin_airport: chicago, destination_airport: new_york, departure_date: tomorrow)
  end
  let!(:chicago_to_atlanta) do
    create(:flight, origin_airport: chicago, destination_airport: atlanta, departure_date: tomorrow)
  end

  it "allows a user to select flight options and create a booking" do
    visit "/"
    select("Chicago, IL", from: "Origin")
    select("New York City, NY", from: "Destination")
    select(2, from: "number")
    fill_in("departure_date", with: tomorrow)
    click_on("Find Flights")
    within(".flight-results") do
      expect(page).to have_content("Available Flights")
      expect(page).to have_content("NYC")
      expect(page).not_to have_content("ATL")
    end
    choose('5:08 PM departure from ORD. Arriving to NYC at 5:09 PM')
    click_on("Book Flight")
    fill_in("booking_passengers_attributes_0_name", with: "Example One")
    fill_in("booking_passengers_attributes_0_email", with: "one@example.com")
    fill_in("booking_passengers_attributes_1_name", with: "Example Two")
    fill_in("booking_passengers_attributes_1_email", with: "two@example.com")
    click_on("Submit Booking")
    within(".booking-results") do
      expect(page).to have_content("Example One")
      expect(page).to have_content("New York City, NY")
      expect(page).not_to have_content("Atlanta, GA")
    end
  end
end
