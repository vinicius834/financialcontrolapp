class ApplicationController < ActionController::Base
  include DeviseHelper
  protect_from_forgery with: :exception

  before_action :configure_sign_up_params, if: :devise_controller?
  before_action :configure_account_update_params, if: :devise_controller?

  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:full_name, :email, :password, :password_confirmation)}
  end

  def configure_account_update_params
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:full_name, :email, :password, :password_confirmation, :current_password)}
  end

  def format_value_to_save(value)
    value.gsub!(/[\.\,]/, '').insert(-3, ".") if (value && value.instance_of?(String) && !value.empty? && value.match(/[\.\,]/))
  end

  def calulate_balance(total_incomes, total_expense)
    Money.new($total_incomes) - Money.new($total_expenses)
  end
end
