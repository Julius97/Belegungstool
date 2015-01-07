class ChangeFormatInAbonnements < ActiveRecord::Migration
  def change
    change_column :abonnements, :playing_day, :integer
  end
end
