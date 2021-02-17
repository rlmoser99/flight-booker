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

# RSpec.describe Seat, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
