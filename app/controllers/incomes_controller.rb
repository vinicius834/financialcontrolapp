class IncomesController < ApplicationController
  before_action :require_authentication, 
    only: [:new, :create, :edit, :update, :destroy]
    
  before_action only: [:create, :update] do
    puts income_params[:value]
    income_params[:value] = format_value_to_save(income_params[:value])
  end

  def new
    @income = Income.new
  end

  def create
    @income = Income.new(income_params)
    @income.user = current_user
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
    @incomes = find_incomes_by_range_dates(from, to)
    @total_incomes = incomes_total_calculate(@incomes) unless @income.blank?
         
    respond_to do |format|
      format.html { render partial: 'income_list' }    
    end
  end

  def all
    @incomes = current_user.incomes 
    @total_incomes = incomes_total_calculate(@incomes)
    respond_to do |format|
      format.html { render partial: 'income_list' }
    end
  end

  private 
  
  def income_params
    params.require(:income).permit(:description, :value, :date)
  end

  def incomes_total_calculate(incomes)
    incomes.inject(0) { |total, income| total + income.value } 
  end
    
  def find_incomes_by_range_dates(from, to)
    if (from.empty? && to.empty?)
      []
    elsif (!from.empty? && to.empty?)
      current_user.incomes.where("date > :date", { date: Date.parse(from) })
    elsif (from.empty? && !to.empty?)
      current_user.incomes.where("date < :date", { date: Date.parse(to) })
    else
      current_user.incomes.where(date: date_range(from, to))  
    end
  end
end
