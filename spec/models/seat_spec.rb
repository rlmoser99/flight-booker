# frozen_string_literal: true

# == Schema Information
#
# Table name: seats
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  booking_id :bigint
#  flight_id  :bigint
#
require 'rails_helper'

RSpec.describe Seat, type: :model do
  subject(:seat) { described_class.new }

  describe 'associations' do
    it { is_expected.to belong_to(:flight) }
    it { is_expected.to belong_to(:booking) }
  end
end
