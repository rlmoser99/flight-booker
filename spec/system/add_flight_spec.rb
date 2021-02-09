# frozen_string_literal: true

require "rails_helper"

RSpec.describe "adding a flight", type: :system do
  it "allows a user to select flight options", :pending do
    visit "/"
    select("Chicago, IL", from: "Origin")
    select("Los Angeles, CA", from: "Destination")
    select("2", from: "Passengers")
    select("5/29/2021", from: "Date")
    click_on("Find Flights")
    expect(page).to have_content("Available Flights")
  end
end
