class IncomesController < ApplicationController
  before_action :authenticate_user!
  before_action only: [:create, :update] do
    income_params[:value] = format_value_to_save(income_params[:value])
  end

  def new
    @income = Income.new
  end

  def create
    @income = current_user.incomes.build(income_params)
    @income.save ? redirect_to(root_path) : render(:new)
  end

  def edit
  	@income = current_user.incomes.find(params[:id])
  end

  def update
    @income = current_user.incomes.find(params[:id])
    @income.update(income_params) ? redirect_to(root_path) : render(:edit)
  end

  def destroy
    @income = current_user.incomes.find(params[:id])
    @income.destroy
    redirect_to root_path
  end

  def search_between_dates
    from = params[:from_date_income]
    to = params[:to_date_income] 
    incomes_searched =  Income.find_incomes_by_range_dates(current_user, from, to)
    @incomes = IncomePresenter.new(incomes_searched, view_context)
    $total_incomes = Income.incomes_total_calculate(incomes_searched)
    @balance = calulate_balance($total_incomes, $total_expenses)
    respond_to do |format|
      format.js {render :search_between_dates}
    end
  end

  def all
    incomes = current_user.incomes
    @incomes = IncomePresenter.new(incomes, view_context)
    $total_incomes = Income.incomes_total_calculate(incomes)
    @balance = calulate_balance($total_incomes, $total_expenses)
    respond_to do |format|
      format.js {render :all}
    end
  end

  private

  def income_params
    params.require(:income).permit(:description, :value, :date)
  end
end
