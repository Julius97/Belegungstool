class AddMailAddressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mail_address, :string
  end
end
