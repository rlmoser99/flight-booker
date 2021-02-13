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
FactoryBot.define do
  factory :passenger do
    name { "MyString" }
    email { "MyString" }
  end
end
