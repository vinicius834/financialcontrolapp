class UserMailer < Devise::Mailer #ActionMailer::Base
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'

  def headers_for(action, opts)
        headers = {
            :subject       => translate(devise_mapping, action),
            :from          => mailer_sender(devise_mapping),
            :to            => resource.email,
            :template_path => 'devise/mailer'
        }.merge(opts)
  end

  def confirmation_instructions(record, token, opts={})
    opts[:subject] = translate('devise.mailer.confirmation_instructions.subject', :confirmation_instructions)
    super
  end

  def reset_password_instructions(record, token, opts={})
    opts[:subject] = translate('devise.mailer.reset_password_instructions.subject', :reset_password_instructions)
    super
  end

  def unlock_instructions(record, token, opts={})
    opts[:subject] = translate('devise.mailer.unlock_instructions.subject', :unlock_instructions)
    super
  end
end
