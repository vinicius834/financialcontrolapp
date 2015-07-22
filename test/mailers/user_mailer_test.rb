require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  tests UserMailer

  def setup
    @user = users(:vinicius)
  end

  test "email sent after creating the user" do
    assert_not_nil confirmation_mail
  end

  test 'send confirmation instructions to the user email' do
    assert_equal [@user.email], confirmation_mail.to
  end

  test 'confirmation instructions from configuration' do
    assert_equal ['signups@financialcontrolapp.com'], confirmation_mail.from
  end

  private

  def confirmation_mail
    @user.send_confirmation_instructions
  end
end
