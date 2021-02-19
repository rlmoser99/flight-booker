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

  describe "#find_flights" do
    before do
      allow(Airport).to receive(:find_by).and_return(san_fran, new_york)
    end

    context 'when flying between two cross-country locations' do
      let!(:cross_country_locations) do
        BookingOptions.new({ "origin_id" => 1,
                             "destination_id" => 2,
                             "departure_date" => tomorrow })
      end

      it "returns two direct and two connecting flight options" do
        result = [
          [morning_direct_flight],
          [evening_direct_flight],
          [morning_SFO_ATL, safe_ATL_NYC],
          [morning_SFO_ORD, safe_ORD_NYC]
        ]
        expect(cross_country_locations.find_flights).to match_array(result)
      end

      it "does not return connecting flight options past the layover window" do
        past_layover_flight = [morning_SFO_ATL, past_ATL_NYC]
        expect(cross_country_locations.find_flights).not_to include(past_layover_flight)
      end
    end

    # Test when:
    # 'when the destination is a layover location' or 'when the origin is a layover location'
    # 'when origin and destination are too close for layover'
  end
end
