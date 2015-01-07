class ChangeFormatInBooking < ActiveRecord::Migration
  def change
  	change_column :bookings, :from_date, :datetime
  	change_column :bookings, :to_date, :datetime
  end
end
