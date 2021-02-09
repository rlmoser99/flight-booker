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
FactoryBot.define do
  factory :airport do
    code { "MyString" }
    location { "MyString" }
  end
end
