class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      Mailer.confirmation_email(@user).deliver
      redirect_to new_user_sessions_path, notice: 'Registered with success! Verify your e-mail.'
    else
      render action: :new
    end
  end

  def edit
  	
  end

  def update
    
  end

  def destroy
    
  end

  private 
  def user_params
    params.require(:user).permit(
    	                         :email, 
    	                         :full_name, 
    	                         :password,
    	                         :password_confirmation)
  end
end