class CreateAbonnements < ActiveRecord::Migration
  def change
    create_table :abonnements do |t|
      t.integer :user_id
      t.integer :court_id
      t.date :from_date
      t.date :to_date

      t.timestamps
    end
  end
end
