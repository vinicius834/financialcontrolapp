require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  tests UserMailer
  
  test "send email to confirmation" do
    user = users(:vinicius)

    email = UserMailer.confirmation_email(user).deliver
    
    assert_not ActionMailer::Base.deliveries.empty?, "E-mail not delivery"
    assert_equal [user.email], email.to
    assert_equal "Confirm email Financial Control App", email.subject
  end
end