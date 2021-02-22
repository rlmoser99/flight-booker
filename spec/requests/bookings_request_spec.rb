# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Bookings", type: :request do
  it "handles a missing booking correctly" do
    get booking_path("not-here")

    expect(response).to redirect_to(root_url)
    expect(flash[:alert]).to eq("Sorry, this booking does not exist.")
  end
end
