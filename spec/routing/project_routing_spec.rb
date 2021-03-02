# frozen_string_literal: true

require "rails_helper"

RSpec.describe "project routing", :aggregate_failures, type: :routing do
  it "routes projects" do
    expect(get: "/flights").to route_to(controller: "flights", action: "index")
    expect(get: "/flights/123").not_to be_routable
    expect(get: "/bookings/new").to route_to(controller: "bookings", action: "new")
    expect(post: "/bookings").to route_to(controller: "bookings", action: "create")
    expect(get: "/bookings/1").to route_to(controller: "bookings", action: "show", id: "1")
    expect(get: "/bookings/1/edit").not_to be_routable
  end
end
