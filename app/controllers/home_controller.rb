class HomeController < ApplicationController
  before_action :require_authentication, only: [:index]
  def index
  	@incomes = current_user.incomes
    @expenses = current_user.expenses
    $total_incomes = @incomes.inject(0) { |total, income| total + income.value }
    $total_expenses = @expenses.inject(0) { |total, expense| total + expense.value }
    @balance = $total_incomes - $total_expenses
  end
end