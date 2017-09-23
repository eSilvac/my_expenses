# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ApplicationRecord
  has_many :expenses
  has_and_belongs_to_many :users, -> { distinct }

  validates :name, presence: true, length: { maximum: 20, too_long: "is too long, max 20 characters" }
end
