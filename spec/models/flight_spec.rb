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
  pending "add some examples to (or delete) #{__FILE__}"
end
