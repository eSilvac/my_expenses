# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test "Category is not created without a name" do
    category = Category.new
    assert_not category.valid?
    assert_not_nil category.errors[:name]
  end
end
