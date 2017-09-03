class ConceptRemoveUnique < ActiveRecord::Migration[5.1]
  def change
    remove_index :expenses, :concept
    add_index :expenses, :concept
  end
end
