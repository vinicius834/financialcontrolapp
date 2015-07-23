class ExpensesController < ApplicationController
  before_action :authenticate_user!

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
    expenses_searched = Expense.find_expenses_by_range_dates(current_user, from, to)
    @expenses = ExpensePresenter.new(expenses_searched, view_context)
    $total_expenses = Expense.expenses_total_calculate(expenses_searched)
    @balance = calulate_balance($total_incomes, $total_expenses)
    respond_to do |format|
      format.js {render :search_between_dates}
    end
  end

  def all
    all_expenses = current_user.expenses 
    @expenses = ExpensePresenter.new(all_expenses, view_context)
    $total_expenses = Expense.expenses_total_calculate(all_expenses)
    @balance = calulate_balance($total_incomes, $total_expenses)
    respond_to do |format|
      format.js {render :all}
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:description, :value, :expiration_date, :paid)
  end
end
