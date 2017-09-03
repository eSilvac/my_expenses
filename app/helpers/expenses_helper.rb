module ExpensesHelper
  def total_amount(expenses)
    return 0 if expenses.count == 0
    
    total = expenses.inject(0) do |total, expense| 
      total + expense.amount
    end
  end

  def average(expenses)
    return 0 if expenses.count == 0
    return total_amount(expenses) / expenses.count
  end

  def months_list
    (Date.today-1.year..Date.today).map{|d| [d.strftime("%b-%Y"), d.strftime("%m-%Y")]}.uniq.reverse
  end
end
