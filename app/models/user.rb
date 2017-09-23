# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string(60)
#  last_name              :string(60)
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :expenses
  has_and_belongs_to_many :categories, -> { distinct }

  before_create :generate_token

  def name
    "#{first_name} #{last_name}"
  end

  def total_amount_day(date)
    total = self.expenses.where(date: date.beginning_of_day..date.end_of_day).inject(0) do |total, expense| 
      total + expense.amount
    end
  end

  def total_amount_month(date)
    total = self.expenses.where(date: date.beginning_of_month..date.end_of_month).inject(0) do |total, expense| 
      total + expense.amount
    end
  end

  def expenses_per_category
    return 0 if self.categories.empty?
  
    res = self.categories.map do |category|
      expense_count = category.expenses.where(user: self).count
      { y: expense_count, indexLabel: category.name }
    end

    return res.to_json
  end

  def last_months_expenses
    return [] if self.expenses.empty?

    res = self.categories.map do |category|
      per_month = (0..5).map do |e|
        date = Date.today-e.month
        { y: category_amount(category, date), label: date.strftime("%b-%Y"), name: category.name }
      end
      { highlightEnabled: false, type: "stackedColumn", dataPoints: per_month.reverse }
    end 

    return res.to_json
  end

  def last_month_expenses
    return [] if self.expenses.empty?

    res = Expense.transaction_types.map do |type, key|
      per_day = (0..(Date.today.day)-1).map do |day|
        date = Date.today-day.day
        { y: type_amount(type, date), label: date.day, name: type.capitalize }
      end
      { type: "stackedColumn", showInLegend: true, legendText: type.capitalize, dataPoints: per_day.reverse }   
    end 

    return res.to_json
  end

  def months_accumulated
    return [] if self.expenses.empty?
    res = []
    
    accumulated = 0
    count_date = (Date.today-1.month).beginning_of_month
    past_month = (0..((Date.today-1.month).end_of_month).day-1).map do |day|
      accumulated += self.total_amount_day(count_date+day.day)
      { x: (count_date+day.day).day, y: accumulated }
    end
    res << { type: "area", showInLegend: true, legendText: "Past Month(#{count_date.strftime("%b-%Y")})" , dataPoints: past_month, markerSize: 0 }

    accumulated = 0
    count_date = Date.today.beginning_of_month
    actual_month = (0..(Date.today.day)-1).map do |day|
      accumulated += self.total_amount_day(count_date+day.day)
      { x: (count_date+day.day).day, y: accumulated }
    end
    res << { type: "area", showInLegend: true, legendText: "Actual Month (#{Date.today.strftime("%b-%Y")})", dataPoints: actual_month, markerSize: 0 }

    return res.to_json
  end

  private
    def generate_token
      self.api_token = Digest::MD5.new.hexdigest(self.email)
    end

    def category_amount(category, date)
      expenses = self.expenses.where(category: category, date: date.beginning_of_month..date.end_of_month)
      total = expenses.inject(0) do |total, expense| 
        total + expense.amount
      end
    end

    def type_amount(type, date)
      expenses = self.expenses.where(transaction_type: type, date: date.beginning_of_day..date.end_of_day)
      total = expenses.inject(0) do |total, expense| 
        total + expense.amount
      end
    end
end
