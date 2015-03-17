class ConfirmationsController < ApplicationController  
  def show
    user = User.find_by(confirmation_token: params[:token])
    if user.present?
      user.confirm!
      redirect_to new_user_sessions_path, notice: 'User confirmed with success! You can log in now.'
    else
      redirect_to new_user_path
    end
  end
end