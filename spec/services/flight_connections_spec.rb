# frozen_string_literal: true

require "rails_helper"

RSpec.describe FlightConnections do
  let!(:san_fran) { create(:airport, id: 1, location: "San Francisco, CA", code: "SFO") }
  let!(:new_york) { create(:airport, id: 2, location: "New York City, NY", code: "NYC") }
  let!(:atlanta) { create(:airport, id: 3, location: "Atlanta, GA", code: "ATL") }
  let!(:chicago) { create(:airport, id: 4, location: "Chicago, IL", code: "ORD") }
  let!(:los_angeles) { create(:airport, id: 5, location: "Los Angeles, CA", code: "LAX") }
  let!(:dallas) { create(:airport, id: 6, location: "Dallas, TX", code: "DFW") }
  let!(:orlando) { create(:airport, id: 7, location: "Orlando, FL", code: "MCO") }
  let!(:denver) { create(:airport, id: 8, location: "Denver, CO", code: "DEN") }

  let(:tomorrow) { Time.zone.tomorrow }
  let(:morning_time) { Time.zone.parse("08:00 AM") }
  let(:noon_time) { Time.zone.parse("12:00 PM") }
  let(:safe_layover_time) { Time.zone.parse("10:00 AM") }
  let(:past_layover_time) { Time.zone.parse("08:00 PM") }

  let!(:morning_SFO_NYC) do
    create(:flight, origin_airport: san_fran,
                    destination_airport: new_york,
                    departure_date: tomorrow,
                    departure_time: morning_time)
  end
  let!(:morning_SFO_ATL) do
    create(:flight, origin_airport: san_fran,
                    destination_airport: atlanta,
                    departure_date: tomorrow,
                    departure_time: morning_time)
  end
  let!(:noon_SFO_ATL) do
    create(:flight, origin_airport: san_fran,
                    destination_airport: atlanta,
                    departure_date: tomorrow,
                    departure_time: noon_time)
  end
  let!(:morning_SFO_ORD) do
    create(:flight, origin_airport: san_fran,
                    destination_airport: chicago,
                    departure_date: tomorrow,
                    departure_time: morning_time)
  end
  let!(:noon_SFO_ORD) do
    create(:flight, origin_airport: san_fran,
                    destination_airport: chicago,
                    departure_date: tomorrow,
                    departure_time: noon_time)
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

  let!(:connections) do
    FlightConnections.new({ "origin_id" => "1", "destination_id" => "2", "departure_date" => tomorrow })
  end
  let!(:non_connection) do
    FlightConnections.new({ "origin_id" => "1", "destination_id" => "3", "departure_date" => tomorrow })
  end
  let!(:close_connection) do
    FlightConnections.new({ "origin_id" => "1", "destination_id" => "5", "departure_date" => tomorrow })
  end

  describe "#find_connections" do
    context 'when connecting San Francisco to New York' do
      it "returns two flights" do
        result = [[morning_SFO_ATL, safe_ATL_NYC], [morning_SFO_ORD, safe_ORD_NYC]]
        expect(connections.find_connections).to match_array(result)
      end
    end

    context 'when connecting San Francisco to Atlanta' do
      it "returns nil" do
        expect(non_connection.find_connections).to be nil
      end
    end

    context 'when connecting San Francisco to "Los Angeles' do
      it "returns true" do
        expect(close_connection.find_connections).to be nil
      end
    end
  end

  describe "#connecting_location?" do
    context 'when connecting San Francisco to New York' do
      it "returns false" do
        expect(connections.connecting_location?).to be false
      end
    end

    context 'when connecting San Francisco to Atlanta' do
      it "returns true" do
        expect(non_connection.connecting_location?).to be true
      end
    end
  end

  describe "#close_location??" do
    context 'when connecting San Francisco to New York' do
      it "returns false" do
        expect(connections.close_location?).to be false
      end
    end

    context 'when connecting San Francisco to "Los Angeles' do
      it "returns true" do
        expect(close_connection.close_location?).to be true
      end
    end
  end

  # describe "#connecting_codes" do
  #   context 'when connecting San Francisco to New York' do
  #     it "returns 4 airport code in an array" do
  #       expect(connections.connecting_codes).to eq([3, 4, 6, 8])
  #     end
  #   end
  # end
end
