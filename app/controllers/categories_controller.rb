class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    @category = Category.find_or_initialize_by(category_params)
    if @category.new_record?
      current_user.categories << @category if @category.save
    else
      current_user.categories << @category
    end
    @categories = current_user.categories.order('name')
  end

  def destroy
    @category = Category.find(params[:id])
    current_user.expenses.where(category: @category).destroy_all
    if @category.users.count == 1
      @category.destroy
    else
      @category.users.delete(current_user)
    end
    @new_expenses_list = current_user.expenses.where(date: Date.today.beginning_of_month..Date.today.end_of_month).order('date DESC')
  end

  private
    def category_params
      params.require(:category).permit(:name)
    end
end
