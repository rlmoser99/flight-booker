# frozen_string_literal: true

class CreateAirports < ActiveRecord::Migration[6.1]
  def change
    create_table :airports do |t|
      t.string :code
      t.string :location

      t.timestamps
    end
  end
end
