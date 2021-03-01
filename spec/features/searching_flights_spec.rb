# frozen_string_literal: true

require 'rails_helper'

RSpec.feature "Users can search flights" do
  let!(:chicago) { create(:airport, :chicago, location: "Chicago, IL") }
  let!(:new_york) { create(:airport, :new_york_city, location: "New York City, NY") }

  let!(:ORD_NYC) { create(:tomorrow_morning_flight, id: 1, origin_airport: chicago, destination_airport: new_york) }

  scenario "with valid selections" do
    visit "/"
    select("Chicago, IL", from: "origin_id")
    select("New York City, NY", from: "destination_id")
    select(2, from: "passenger_count")
    fill_in("departure_date", with: Time.zone.tomorrow)
    click_on("Find Flights")
    within(".flight-results") do
      expect(page).to have_content("Available Flights")
      expect(page).to have_content("NYC")
    end
  end

  scenario "with invalid matching origin and destination airports" do
    visit "/"
    select("Chicago, IL", from: "origin_id")
    select("Chicago, IL", from: "destination_id")
    select(2, from: "passenger_count")
    fill_in("departure_date", with: Time.zone.tomorrow)
    click_on("Find Flights")
    within(".flash-message") do
      expect(page).to have_content("Please choose two different origin and destination locations!")
    end
  end

  scenario "with no available flights today" do
    visit "/"
    select("Chicago, IL", from: "origin_id")
    select("New York City, NY", from: "destination_id")
    select(2, from: "passenger_count")
    fill_in("departure_date", with: Time.zone.today)
    click_on("Find Flights")
    within(".flight-results") do
      expect(page).to have_content("Sorry, no flights match your search criteria.")
      expect(page).not_to have_content("Book Flight")
    end
  end
end
