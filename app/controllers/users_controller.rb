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
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to root_path, notice: 'Profile updated with success.'
    else
      render action: :edit
    end
  end

  def destroy
    
  end

  private 
  def user_params
    params.require(:user)
          .permit(:email, 
                  :full_name, 
                  :password,
                  :password_confirmation)
  end
end