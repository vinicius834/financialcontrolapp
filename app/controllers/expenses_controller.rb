class ExpensesController < ApplicationController
  before_action :require_authentication, 
    only: [:new, :create, :edit, :update, :destroy]
  
  before_action only: [:create, :update] do
    expense_params[:value] = format_value_to_save(expense_params[:value])
  end
  
  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)
    @expense.user = User.first
    @expense.save ? redirect_to(root_path) : render(:new)
  end

  def edit
    @expense = User.first.expenses.find(params[:id])
  end

  def update
    @expense = User.first.expenses.find(params[:id])
    @expense.update(expense_params) ? redirect_to(root_path) : render(:edit)
  end

  def destroy
    @expense = User.first.expenses.find(params[:id])
    @expense.destroy
    redirect_to root_path
  end
    
  def search_between_dates
    puts params
    from = params[:from_date_expense]
    to = params[:to_date_expense]
    @expenses = find_expenses_by_range_dates(from, to) 
    @total_expenses = expenses_total_calculate(@expenses) unless @expenses.blank?
      
    respond_to do |format|
      format.html { render partial: 'expense_list' }    
    end
  end

  def all
    @expenses = current_user.expenses 
    @total_expenses = expenses_total_calculate(@expenses)
    respond_to do |format|
      format.html { render partial: 'expense_list' }
    end
  end
  
  private
  
  def expense_params
    params.require(:expense).permit(:description, :value, :expiration_date, :paid)
  end
    
  def expenses_total_calculate(expenses)
    expenses.inject(0) { |total, expense| total + expense.value } 
  end
    
  def find_expenses_by_range_dates(from, to)
    if (from.empty? && to.empty?)
      []
    elsif (!from.empty? && to.empty?)
      current_user.expenses.where("expiration_date > :expiration_date", 
          { expiration_date: Date.parse(from) })
    elsif (from.empty? && !to.empty?)
      current_user.expenses.where("expiration_date < :expiration_date", 
          { expiration_date: Date.parse(to) })
    else
      current_user.expenses.where(expiration_date: date_range(from, to))  
    end
  end
end