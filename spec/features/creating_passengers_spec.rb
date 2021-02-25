# frozen_string_literal: true

require 'rails_helper'

RSpec.feature "Users can create passengers" do
  let!(:chicago) { create(:airport, :chicago) }
  let!(:new_york) { create(:airport, :new_york_city) }

  let!(:ORD_NYC) { create(:tomorrow_morning_flight, id: 1, origin_airport: chicago, destination_airport: new_york) }

  scenario "with valid attributes" do
    visit "/bookings/new/?passenger_count=1&booking_option=1&commit=Book+Flight"
    fill_in("booking_passengers_attributes_0_name", with: "Example Name")
    fill_in("booking_passengers_attributes_0_email", with: "name@example.com")
    click_on("Submit Booking")
    within(".content-container") do
      expect(page).to have_content("Example Name")
      expect(page).to have_content("NYC")
    end
  end

  scenario "when providing invalid attributes" do
    visit "/bookings/new/?passenger_count=1&booking_option=1&commit=Book+Flight"
    fill_in("booking_passengers_attributes_0_name", with: "short")
    fill_in("booking_passengers_attributes_0_email", with: "short.com")
    click_on("Submit Booking")
    within("form") do
      expect(page).to have_content("Passengers name is too short")
      expect(page).to have_content("Passengers email is too short")
    end
  end
end