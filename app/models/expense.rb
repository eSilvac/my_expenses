# == Schema Information
#
# Table name: expenses
#
#  id               :integer          not null, primary key
#  transaction_type :integer
#  concept          :string
#  amount           :float
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#  category_id      :integer
#

class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :concept, presence: true
  validates :transaction_type, presence: true
  validates :amount, presence: true

  enum transaction_type: [:purchase, :withdrawal, :transfer, :payment]
end
