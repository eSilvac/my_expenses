class Api::V1::ExpensesController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate

  def index
    @expenses = Expense.where(user: token_user)
    @expenses = @expenses.where(category_id: params[:category_id]) if params[:category_id].present?    
    @expenses = @expenses.where(transaction_type: params[:type]) if params[:type].present?
  end

  def create
    if category_verify
      @expense = Expense.new(expense_params.merge(user: token_user))
      if @expense.save
        render json: @expense, status: 201
      else
        render json: { errors: @expense.errors }, status: 422
      end
    else
      head 403
    end
  end

  def update
    @expense = Expense.find(params[:id])
    if @expense.user == token_user && category_verify
      if @expense.update(expense_params)
        render json: @expense, status: 204
      else
        render json: { errors: @expense.errors }, status: 422
      end
    else
      head 403
    end
  end

  def destroy
    @expense = Expense.find(params[:id])
    if @expense.user == token_user
      @expense.destroy
      head 204
    else
      head 403
    end
  end

  private
    def expense_params
      params.require(:expense).permit(:concept, :amount, :transaction_type, :category_id, :date)
    end

    def authenticate
      unless User.where(api_token: request.headers['HTTP_X_API_TOKEN']).exists? 
        head 401
      end
    end

    def token_user
      User.find_by(api_token: request.headers['HTTP_X_API_TOKEN'])
    end

    def category_verify
      token_user.categories.where(id: expense_params[:category_id]).exists?
    end
end