class CreateBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings do |t|
      t.bigint :flight_id
      t.bigint :passenger_id

      t.timestamps
    end
  end
end
