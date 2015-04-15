class UserMailer < ActionMailer::Base
  default from: 'no-reply@financialcontrolapp.com'
  
  def confirmation_email(user)
  	@user = user
    @confirmation_link = confirmation_url({
      token: @user.confirmation_token
    })
    mail({
      to: user.email,
      bcc: ['sign ups <signups@financialcontrolapp.com>'],
      subject: 'Confirm email Financial Control App'
    })  
  end
    
  def password_reset(user) 
    @user = user
    @reset_link = edit_password_reset_url(@user.password_reset_token)
    mail({
      to: user.email,
      bcc: ['password resets <passwordresets@financialcontrolapp.com>'],
      subject: 'Password reset email'
    }) 
  end 
end
