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

require 'test_helper'

class ExpenseTest < ActiveSupport::TestCase
  test "Expense is not created without any param" do
    expense = Expense.new
    assert_not expense.valid?
  end
end
