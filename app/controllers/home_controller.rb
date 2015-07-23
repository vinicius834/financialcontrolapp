class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
  	incomes = current_user.incomes
    expenses = current_user.expenses
    @incomes = IncomePresenter.new(incomes, view_context)
    @expenses = ExpensePresenter.new(expenses, view_context)
    $total_incomes = Income.incomes_total_calculate(incomes)
    $total_expenses = Expense.expenses_total_calculate(expenses)
    @balance = calulate_balance($total_incomes, $total_expenses)
  end
end
