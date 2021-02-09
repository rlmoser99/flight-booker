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
  pending "add some examples to (or delete) #{__FILE__}"
end
