# frozen_string_literal: true

# == Schema Information
#
# Table name: passengers
#
#  id         :bigint           not null, primary key
#  email      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  booking_id :bigint
#
require 'rails_helper'

RSpec.describe Passenger, type: :model do
  subject(:passenger) { described_class.new }

  describe 'associations' do
    it { is_expected.to belong_to(:booking) }
    it { is_expected.to have_many(:flights).through(:booking) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
  end
end
