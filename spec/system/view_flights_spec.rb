# frozen_string_literal: true

require "rails_helper"

RSpec.describe "view available flights", type: :system do
  let(:tomorrow) { Time.zone.tomorrow }
  let!(:chicago) { create(:airport, location: "Chicago, IL") }
  let!(:new_york) { create(:airport, location: "New York, NY") }
  let!(:atlanta) { create(:airport, location: "Atlanta, GA") }
  let!(:chicago_to_newyork) do
    create(:flight, origin_airport: chicago, destination_airport: new_york, departure_date: tomorrow)
  end
  let!(:chicago_to_atlanta) do
    create(:flight, origin_airport: chicago, destination_airport: atlanta, departure_date: tomorrow)
  end

  it "allows a user to select flight options and view correct results" do
    visit "/"
    select("Chicago, IL", from: "Origin")
    select("New York, NY", from: "Destination")
    select(2, from: "number")
    fill_in("departure_date", with: tomorrow)
    click_on("Find Flights")
    within(".flight-results") do
      expect(page).to have_content("Available Flights")
      expect(page).to have_content("New York, NY")
      expect(page).not_to have_content("Atlanta, GA")
    end
  end
end
