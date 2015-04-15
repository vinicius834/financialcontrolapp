class UserSession
  include ActiveModel::Model
  
  attr_accessor :email
  attr_accessor :password
  validates_presence_of :email, :password
 
  def initialize(session, attributes={})
    @session = session
    @email = attributes[:email]
    @password = attributes[:password]
  end
  
  def authenticate!
    user = User.authenticate(@email, @password)
    if user.present?
      store(user)
    else
      errors.add(:base, 'Invalid login!')
      false
    end
  end

  def store(user)
    @session[:user_id] = user.id
    @session[:full_name] = user.full_name
  end

  def current_user
    user ||= User.find(@session[:user_id])
    user
  end

  def user_signed_in?
    @session[:user_id].present?
  end

  def destroy
    @session[:user_id] = nil
    @session[:full_name] = nil
  end
end