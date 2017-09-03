class CreateExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :expenses do |t|
      t.integer :type
      t.string :concept
      t.float :amount

      t.timestamps
    end
    add_index :expenses, :concept, unique: true
  end
end
