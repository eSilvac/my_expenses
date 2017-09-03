class AddNameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :first_name, :string, limit: 60
    add_column :users, :last_name, :string, limit: 60
  end
end
