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
    @expense.user = current_user
    @expense.save ? redirect_to(root_path) : render(:new)
  end

  def edit
    @expense = current_user.expenses.find(params[:id])
  end

  def update
    @expense = current_user.expenses.find(params[:id])
    @expense.update(expense_params) ? redirect_to(root_path) : render(:edit)
  end

  def destroy
    @expense = current_user.expenses.find(params[:id])
    @expense.destroy
    redirect_to root_path
  end
    
  def search_between_dates
    from = params[:from_date_expense]
    to = params[:to_date_expense]
    @expenses = find_expenses_by_range_dates(from, to) 
    $total_expenses = expenses_total_calculate(@expenses)
    @balance = calulate_balance($total_incomes, $total_expenses)
    respond_to do |format|
      format.js {render :search_between_dates}
    end
  end

  def all
    @expenses = current_user.expenses 
    $total_expenses = expenses_total_calculate(@expenses)
    @balance = calulate_balance($total_incomes, $total_expenses)
    respond_to do |format|
      format.js {render :all}
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
      current_user.expenses.where("expiration_date >= :from", 
          { from: Date.parse(from) })
    elsif (from.empty? && !to.empty?)
      current_user.expenses.where("expiration_date <= :to", 
          { to: Date.parse(to) })
    else
      current_user.expenses.where(expiration_date: date_range(from, to))  
    end
  end
end