class AddColumnsToAbonnements < ActiveRecord::Migration
  def change
    add_column :abonnements, :playing_time_starts, :time
    add_column :abonnements, :playing_time_ends, :time
    add_column :abonnements, :playing_day, :string
  end
end
