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
    it { is_expected.to have_many(:seats) }
    it { is_expected.to have_many(:bookings) }
    it { is_expected.to have_many(:passengers) }
  end
end
