class HomeController < ApplicationController
  before_action :require_authentication, only: [:index]
  def index
  	@incomes = current_user.incomes
    @expenses = current_user.expenses
    $total_incomes = Income.incomes_total_calculate(@incomes) 
    $total_expenses = Expense.expenses_total_calculate(@expenses)
    @balance = calulate_balance($total_incomes, $total_expenses)
  end
end
