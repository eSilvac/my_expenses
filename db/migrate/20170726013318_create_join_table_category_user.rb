class CreateJoinTableCategoryUser < ActiveRecord::Migration[5.1]
  def change
    create_join_table :categories, :users do |t|
      t.references :category, foreign_key: { on_delete: :cascade }
      t.references :user, foreign_key: { on_delete: :cascade }
    end
  end
end
