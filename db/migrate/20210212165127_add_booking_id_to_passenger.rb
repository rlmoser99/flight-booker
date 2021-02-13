# frozen_string_literal: true

class AddBookingIdToPassenger < ActiveRecord::Migration[6.1]
  def change
    add_column :passengers, :booking_id, :bigint
  end
end
