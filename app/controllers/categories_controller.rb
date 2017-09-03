class CategoriesController < ApplicationController
  def destroy
    @category = Category.find(params[:id])
    current_user.expenses.where(category: @category).destroy_all
    @category.users.delete(current_user)
    @new_expenses_list = current_user.expenses
    @new_expenses_list = @new_expenses_list.where(date: Date.today.beginning_of_month..Date.today.end_of_month).order('date DESC')
  end
end
