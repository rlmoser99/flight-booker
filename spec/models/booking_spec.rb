# frozen_string_literal: true

# == Schema Information
#
# Table name: bookings
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  flight_id    :bigint
#  passenger_id :bigint
#
require 'rails_helper'

RSpec.describe Booking, type: :model do
  subject(:booking) { described_class.new }

  describe 'associations' do
    it { is_expected.to have_many(:passengers) }
    it { is_expected.to have_many(:seats) }
    it { is_expected.to have_many(:flights) }
    it { should accept_nested_attributes_for(:passengers) }
  end
end
