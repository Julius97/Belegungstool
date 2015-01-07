class ChangeFormateInAbonnement < ActiveRecord::Migration
  def change
  	change_column :abonnements, :playing_time_starts, :datetime
  	change_column :abonnements, :playing_time_ends, :datetime
  end
end
