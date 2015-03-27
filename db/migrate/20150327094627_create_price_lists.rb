class CreatePriceLists < ActiveRecord::Migration
  def change
    create_table :price_lists do |t|
      t.decimal :price, precision: 5, scale: 2
      t.string :lesson
      t.datetime :from_time
      t.datetime :to_time

      t.timestamps
    end
  end
end
