class CreateTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :tickets do |t|
      t.bigint :booking_id
      t.bigint :passenger_id
      t.bigint :flight_id

      t.timestamps
    end
  end
end
