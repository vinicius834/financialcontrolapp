class Mailer < ActionMailer::Base
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
end
