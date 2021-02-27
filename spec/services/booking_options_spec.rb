# frozen_string_literal: true

require "rails_helper"

RSpec.describe BookingOptions do
  let(:san_fran) { create(:airport, :san_francisco) }
  let(:new_york) { create(:airport, :new_york_city) }
  let(:atlanta) { create(:airport, :atlanta) }
  let(:chicago) { create(:airport, :chicago) }

  # 2 long direct flights SFO to NYC
  let(:morning_SFO_NYC) { create(:tomorrow_morning_long_flight, origin_id: san_fran.id, destination_id: new_york.id) }
  let(:night_SFO_NYC) { create(:tomorrow_night_long_flight, origin_id: san_fran.id, destination_id: new_york.id) }

  # Connecting flight pair through ORD
  let(:morning_SFO_ORD) { create(:tomorrow_morning_flight, origin_id: san_fran.id, destination_id: chicago.id) }
  let(:layover_ORD_NYC) { create(:tomorrow_layover_flight, origin_id: chicago.id, destination_id: new_york.id) }

  # Connecting flight pair through ATL
  let(:morning_SFO_ATL) { create(:tomorrow_morning_flight, origin_id: san_fran.id, destination_id: atlanta.id) }
  let(:layover_ATL_NYC) { create(:tomorrow_layover_flight, origin_id: atlanta.id, destination_id: new_york.id) }

  # Second leg option that will not be used for connecting through ATL
  let(:night_ATL_NYC) { create(:tomorrow_night_flight, origin_id: atlanta.id, destination_id: new_york.id) }

  let(:tomorrow) { Time.zone.tomorrow }

  describe "#find_flights" do
    context 'when flying between two cross-country locations' do
      let(:cross_country_locations) do
        BookingOptions.new({ "origin_id" => san_fran.id,
                             "destination_id" => new_york.id,
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
      # 1 more direct flight SFO to ORD
      let(:night_SFO_ORD) { create(:tomorrow_morning_short_flight, origin_id: san_fran.id, destination_id: chicago.id) }

      # Unnecessary connecting flight pair through ATL (that will not be used)
      let(:morning_SFO_ATL) { create(:tomorrow_morning_flight, origin_id: san_fran.id, destination_id: atlanta.id) }
      let(:layover_ATL_ORD) { create(:tomorrow_layover_flight, origin_id: atlanta.id, destination_id: chicago.id) }

      let(:one_layover_location) do
        BookingOptions.new({ "origin_id" => san_fran.id,
                             "destination_id" => chicago.id,
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
      let(:los_angeles) { create(:airport, :los_angeles) }

      # 2 direct flights SFO to LAX
      let(:morning_SFO_LAX) { create(:tomorrow_morning_short_flight, origin_id: san_fran.id, destination_id: los_angeles.id) }
      let(:night_SFO_LAX) { create(:tomorrow_night_short_flight, origin_id: san_fran.id, destination_id: los_angeles.id) }

      # Unnecessary connecting flight pair through ATL (that will not be used)
      let(:morning_SFO_ATL) { create(:tomorrow_morning_flight, origin_id: san_fran.id, destination_id: atlanta.id) }
      let(:layover_ATL_LAX) { create(:tomorrow_layover_flight, origin_id: atlanta.id, destination_id: los_angeles.id) }

      let(:close_locations) do
        BookingOptions.new({ "origin_id" => san_fran.id,
                             "destination_id" => los_angeles.id,
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
