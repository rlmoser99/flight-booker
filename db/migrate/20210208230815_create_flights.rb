# frozen_string_literal: true

class CreateFlights < ActiveRecord::Migration[6.1]
  def change
    create_table :flights do |t|
      t.bigint :origin_id
      t.bigint :destination_id
      t.date :departure_date
      t.time :departure_time
      t.integer :duration

      t.timestamps
    end
  end
end
