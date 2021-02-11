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

# RSpec.describe Booking, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
