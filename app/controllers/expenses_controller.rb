class ExpensesController < ApplicationController
  before_action :authenticate_user!

  def index
    @tab = :expenses
    @categories = current_user.categories.order('name')

    @expenses = current_user.expenses.order('date DESC')
    @expenses = @expenses.where(category: params[:category]) if params[:category].present?    
    @expenses = @expenses.where(transaction_type: params[:transaction]) if params[:transaction].present?
    @expenses = @expenses.where("concept LIKE ?", "%#{params[:q]}%") if params[:q].present?
    @expenses = date_param?(@expenses)
    @expenses_paginated = @expenses.paginate(:page => params[:page], :per_page => 8)
  end

  def new
    @expense = Expense.new
  end

  def create
    if expense_params[:new_category_name] != nil 
      @category = Category.find_or_initialize_by(name: expense_params[:new_category_name])
      @expense = Expense.create(expense_params.merge(user: current_user).except(:new_category_name))
      if @expense.errors.count == 1
        @category.save if @category.new_record?
        @category.users << current_user
        @category.expenses << @expense if @category.errors.empty?
      end
    else
      @expense = Expense.create(expense_params.merge(user: current_user))
      @category = Category.where(id: params[:category_id]).take
    end
    @categories = current_user.categories.order('name')
    @expenses = current_user.expenses.where(date: @expense.date.beginning_of_month..@expense.date.end_of_month).order('date DESC') if @expense.valid?
    @expenses = @expenses.paginate(:page => params[:page], :per_page => 8) if @expense.valid?
  end

  def edit
    @expense = Expense.find(params[:id])
  end

  def update
    @categories = Category.all
    @expense = Expense.find(params[:id])
    if expense_params[:new_category_name] != nil 
      @category = Category.find_or_initialize_by(name: expense_params[:new_category_name])
      @category.save if @category.new_record?
      @category.users << current_user
      @category.expenses << @expense if @category.errors.empty?
    end
    @expense.update(expense_params.except(:new_category_name))
    @categories = current_user.categories.order('name')
  end

  def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy
  end

  private
    def expense_params
      params.require(:expense).permit(:concept, :amount, :transaction_type, :category_id, :date, :new_category_name)
    end

    def date_param?(expenses)
      if params[:date].present?
        begin_date = Date.strptime(params[:date], '%m-%Y')
        end_date = begin_date.end_of_month
        expenses = expenses.where(date: begin_date..end_date).order('date DESC')
      else
        expenses = expenses.where(date: Date.today.beginning_of_month..Date.today.end_of_month).order('date DESC')
      end
    end
end
