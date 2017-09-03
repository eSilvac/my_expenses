class RenameColumnType < ActiveRecord::Migration[5.1]
  def change
    rename_column :expenses, :type, :transaction_type
  end
end
