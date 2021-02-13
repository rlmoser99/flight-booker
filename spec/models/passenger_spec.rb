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

# RSpec.describe Passenger, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
