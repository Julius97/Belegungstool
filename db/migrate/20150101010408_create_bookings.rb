class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :user_id
      t.integer :court_id
      t.datetime :from_date
      t.datetime :to_date

      t.timestamps
    end
  end
end
