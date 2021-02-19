# frozen_string_literal: true

# == Schema Information
#
# Table name: airports
#
#  id         :bigint           not null, primary key
#  code       :string
#  location   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Airport, type: :model do
  subject(:airport) { described_class.new }

  describe 'associations' do
    it { is_expected.to have_many(:arriving_flights).dependent(:destroy) }
    it { is_expected.to have_many(:departing_flights).dependent(:destroy) }
  end
end
