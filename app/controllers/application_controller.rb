class ApplicationController < ActionController::Base
  delegate :current_user, :user_signed_in?, to: :user_session
  helper_method :current_user, :user_signed_in?
 
  protect_from_forgery with: :exception

  def user_session
    UserSession.new(session)
  end

  def require_authentication
    unless user_signed_in?
      redirect_to new_user_sessions_path
    end
  end

  def require_no_authentication
  	if user_signed_in?
      redirect_to root_path
    end
  end
    
  def format_value_to_save(value)
    value.gsub!(/[\.\,]/, '').insert(-3, ".") if (value && value.instance_of?(String) && !value.empty? && value.match(/[\.\,]/))

  end
  
  def date_range(from_date, to_date)
    from_date = Date.parse(from_date)
    to_date =  Date.parse(to_date)
    from_date..to_date
  end
  
  def calulate_balance(total_incomes, total_expense)
    total_incomes - total_expense   
  end
end
