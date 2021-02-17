# frozen_string_literal: true

class CreateSeats < ActiveRecord::Migration[6.1]
  def change
    create_table :seats do |t|
      t.bigint :booking_id
      t.bigint :flight_id

      t.timestamps
    end
  end
end
