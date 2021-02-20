# frozen_string_literal: true

require "rails_helper"

RSpec.describe BookingOptions do
  let(:san_fran) { create(:airport, :north_california) }
  let(:new_york) { create(:airport, :east_coast) }
  let(:atlanta) { create(:airport, :atlanta_layover) }
  let(:chicago) { create(:airport, :chicago_layover) }

  let(:morning_SFO_ATL) { create(:tomorrow_morning_flight, origin_airport: san_fran, destination_airport: atlanta) }
  let(:morning_SFO_ORD) { create(:tomorrow_morning_flight, origin_airport: san_fran, destination_airport: chicago) }
  let(:morning_SFO_NYC) { create(:tomorrow_morning_flight, origin_airport: san_fran, destination_airport: new_york) }
  let(:layover_ATL_NYC) { create(:tomorrow_layover_flight, origin_airport: atlanta, destination_airport: new_york) }
  let(:layover_ORD_NYC) { create(:tomorrow_layover_flight, origin_airport: chicago, destination_airport: new_york) }
  let(:night_ATL_NYC) { create(:tomorrow_night_flight, origin_airport: atlanta, destination_airport: new_york) }
  let(:night_SFO_NYC) { create(:tomorrow_night_flight, origin_airport: san_fran, destination_airport: new_york) }

  let(:tomorrow) { Time.zone.tomorrow }

  describe "#find_flights" do
    context 'when flying between two cross-country locations' do
      let(:san_fran_id) { 1 }
      let(:new_york_id) { 2 }
      let(:cross_country_locations) do
        BookingOptions.new({ "origin_id" => san_fran_id,
                             "destination_id" => new_york_id,
                             "departure_date" => tomorrow })
      end

      before do
        allow(Airport).to receive(:find_by).and_return(san_fran, new_york)
      end

      it "returns two SFO-NYC direct and two connecting flight options" do
        result = [
          [morning_SFO_NYC],
          [night_SFO_NYC],
          [morning_SFO_ATL, layover_ATL_NYC],
          [morning_SFO_ORD, layover_ORD_NYC]
        ]
        expect(cross_country_locations.find_flights).to match_array(result)
      end

      it "does not return connecting flight options past the layover window" do
        past_layover_connection = [morning_SFO_ATL, night_ATL_NYC]
        expect(cross_country_locations.find_flights).not_to include(past_layover_connection)
      end
    end

    context 'when flying to/from a layover location' do
      let(:night_SFO_ORD) { create(:tomorrow_morning_flight, origin_airport: san_fran, destination_airport: chicago) }
      let(:morning_SFO_ATL) { create(:tomorrow_morning_flight, origin_airport: san_fran, destination_airport: atlanta) }
      let(:layover_ATL_ORD) { create(:tomorrow_layover_flight, origin_airport: atlanta, destination_airport: chicago) }

      let(:san_fran_id) { 1 }
      let(:chicago_id) { 4 }
      let(:one_layover_location) do
        BookingOptions.new({ "origin_id" => san_fran_id,
                             "destination_id" => chicago_id,
                             "departure_date" => tomorrow })
      end

      before do
        allow(Airport).to receive(:find_by).and_return(san_fran, chicago)
      end

      it "returns two SFO-ORD direct flight options" do
        result = [
          [morning_SFO_ORD],
          [night_SFO_ORD]
        ]
        expect(one_layover_location.find_flights).to match_array(result)
      end

      it "does not return connecting flight options through another layover location" do
        unnecessary_first_leg = morning_SFO_ATL
        unnecessary_second_leg = layover_ATL_ORD
        expect(one_layover_location.find_flights).not_to include(unnecessary_first_leg, unnecessary_second_leg)
      end
    end

    context 'when origin and destination are too close for layover' do
      let(:los_angeles) { create(:airport, :south_california) }
      let(:morning_SFO_LAX) { create(:tomorrow_morning_flight, origin_airport: san_fran, destination_airport: los_angeles) }
      let(:night_SFO_LAX) { create(:tomorrow_night_flight, origin_airport: san_fran, destination_airport: los_angeles) }
      let(:morning_SFO_ATL) { create(:tomorrow_morning_flight, origin_airport: san_fran, destination_airport: atlanta) }
      let(:layover_ATL_LAX) { create(:tomorrow_layover_flight, origin_airport: atlanta, destination_airport: los_angeles) }
      let(:san_fran_id) { 1 }
      let(:los_angeles_id) { 5 }
      let(:close_locations) do
        BookingOptions.new({ "origin_id" => san_fran_id,
                             "destination_id" => los_angeles_id,
                             "departure_date" => tomorrow })
      end

      before do
        allow(Airport).to receive(:find_by).and_return(san_fran, los_angeles)
      end

      it "returns two SFO-LAX direct flight options" do
        result = [
          [morning_SFO_LAX],
          [night_SFO_LAX]
        ]
        expect(close_locations.find_flights).to match_array(result)
      end

      it "does not return connecting flight options through another layover location" do
        unnecessary_first_leg = morning_SFO_ATL
        unnecessary_second_leg = layover_ATL_LAX
        expect(close_locations.find_flights).not_to include(unnecessary_first_leg, unnecessary_second_leg)
      end
    end
  end
end
