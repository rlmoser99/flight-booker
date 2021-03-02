# frozen_string_literal: true

# == Schema Information
#
# Table name: flights
#
#  id             :bigint           not null, primary key
#  departure_date :date
#  departure_time :time
#  duration       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  destination_id :bigint
#  origin_id      :bigint
#
require 'rails_helper'

RSpec.describe Flight, type: :model do
  subject(:flight) { described_class.new }

  describe 'associations' do
    it { is_expected.to belong_to(:origin_airport) }
    it { is_expected.to belong_to(:destination_airport) }
    it { is_expected.to have_many(:seats).dependent(:destroy) }
    it { is_expected.to have_many(:bookings).through(:seats) }
    it { is_expected.to have_many(:passengers).through(:bookings) }
  end

  context 'for methods that return ' do
    let(:san_fran) { create(:airport, :san_francisco) }
    let(:new_york) { create(:airport, :new_york_city) }
    subject(:flight_to_NYC) do
      create(:flight,
             origin_id: san_fran.id,
             destination_id: new_york.id,
             departure_date: Time.zone.parse("April 1, 2022"),
             departure_time: Time.zone.parse("08:00 AM"),
             duration: 60)
    end

    describe '#details' do
      it 'returns flight details' do
        expect(flight_to_NYC.details).to eq(" 8:00 AM departure from SFO and arrive at  9:00 AM to NYC")
      end
    end

    describe '#humanize_departure' do
      it 'returns the humanize_arrival for flight' do
        expect(flight_to_NYC.humanize_departure).to eq(" 8:00 AM")
      end
    end

    describe '#humanize_arrival' do
      it 'returns the humanize_arrival for flight' do
        expect(flight_to_NYC.humanize_arrival).to eq(" 9:00 AM")
      end
    end

    describe '#humanize_date' do
      it 'returns the humanize_arrival for flight' do
        expect(flight_to_NYC.humanize_date).to eq("April 01, 2022")
      end
    end
  end
end
