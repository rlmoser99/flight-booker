# frozen_string_literal: true

require "rails_helper"

RSpec.describe BookingOptions do
  # Update these tests using traits in Factory Bot!!!
  # https://www.codewithjason.com/deal-complex-factory-bot-associations-rspec-tests/

  let!(:san_fran) { create(:airport, id: 1, location: "San Francisco, CA", code: "SFO") }
  let!(:new_york) { create(:airport, id: 2, location: "New York City, NY", code: "NYC") }
  let!(:atlanta) { create(:airport, id: 3, location: "Atlanta, GA", code: "ATL") }
  let!(:chicago) { create(:airport, id: 4, location: "Chicago, IL", code: "ORD") }
  let!(:los_angeles) { create(:airport, id: 5, location: "Los Angeles, CA", code: "LAX") }

  let(:tomorrow) { Time.zone.tomorrow }
  let(:morning_time) { Time.zone.parse("08:00 AM") }
  let(:safe_layover_time) { Time.zone.parse("10:00 AM") }
  let(:past_layover_time) { Time.zone.parse("08:00 PM") }

  let!(:morning_SFO_ATL) do
    create(:flight, origin_airport: san_fran,
                    destination_airport: atlanta,
                    departure_date: tomorrow,
                    departure_time: morning_time)
  end
  let!(:morning_SFO_ORD) do
    create(:flight, origin_airport: san_fran,
                    destination_airport: chicago,
                    departure_date: tomorrow,
                    departure_time: morning_time)
  end
  let!(:safe_ATL_NYC) do
    create(:flight, origin_airport: atlanta,
                    destination_airport: new_york,
                    departure_date: tomorrow,
                    departure_time: safe_layover_time)
  end
  let!(:safe_ORD_NYC) do
    create(:flight, origin_airport: chicago,
                    destination_airport: new_york,
                    departure_date: tomorrow,
                    departure_time: safe_layover_time)
  end
  let!(:past_ATL_NYC) do
    create(:flight, origin_airport: atlanta,
                    destination_airport: new_york,
                    departure_date: tomorrow,
                    departure_time: past_layover_time)
  end
  let!(:past_ORD_NYC) do
    create(:flight, origin_airport: chicago,
                    destination_airport: new_york,
                    departure_date: tomorrow,
                    departure_time: past_layover_time)
  end
  let!(:morning_direct_flight) do
    create(:flight, origin_airport: san_fran,
                    destination_airport: new_york,
                    departure_date: tomorrow,
                    departure_time: morning_time)
  end
  let!(:evening_direct_flight) do
    create(:flight, origin_airport: san_fran,
                    destination_airport: new_york,
                    departure_date: tomorrow,
                    departure_time: past_layover_time)
  end

  # Fix these tests to use the new method: #find_flights

  describe "#find_connecting_flights" do
    context 'when connecting cross-country locations' do
      let!(:cross_country_locations) do
        BookingOptions.new({ "origin_id" => san_fran.id,
                             "destination_id" => new_york.id,
                             "departure_date" => tomorrow })
      end

      it "returns two connecting flight options" do
        result = [
          [morning_direct_flight],
          [evening_direct_flight],
          [morning_SFO_ATL, safe_ATL_NYC],
          [morning_SFO_ORD, safe_ORD_NYC]
        ]
        expect(cross_country_locations.find_flights).to match_array(result)
      end

      it "does not return flights options past layover window" do
        result = [[morning_SFO_ATL, past_ATL_NYC], [morning_SFO_ORD, past_ORD_NYC]]
        expect(cross_country_locations.find_connecting_flights).not_to include(result)
      end
    end

    context 'when the destination is a layover location' do
      let!(:destination_layover) do
        BookingOptions.new({ "origin_id" => san_fran.id,
                             "destination_id" => atlanta.id,
                             "departure_date" => tomorrow })
      end

      it "returns nil" do
        expect(destination_layover.find_connecting_flights).to eq([])
      end
    end

    context 'when the origin is a layover location' do
      let!(:origin_layover) do
        BookingOptions.new({ "origin_id" => atlanta.id,
                             "destination_id" => san_fran.id,
                             "departure_date" => tomorrow })
      end

      it "returns nil" do
        expect(origin_layover.find_connecting_flights).to eq([])
      end
    end

    context 'when origin and destination are too close for layover' do
      let!(:non_layover_locations) do
        BookingOptions.new({ "origin_id" => san_fran.id,
                             "destination_id" => los_angeles.id,
                             "departure_date" => tomorrow })
      end

      it "returns nil" do
        expect(non_layover_locations.find_connecting_flights).to eq([])
      end
    end
  end

  # describe 'find_flights' do
  #   let!(:cross_country_locations) do
  #     BookingOptions.new({ "origin_id" => san_fran.id,
  #                          "destination_id" => new_york.id,
  #                          "departure_date" => tomorrow })
  #   end

  #   it "returns two flights" do
  #     results = [[morning_direct_flight], [evening_direct_flight]]
  #     expect(cross_country_locations.find_flights).to eq(results)
  #   end
  # end
end
