require 'test_helper'

class UserTest < ActiveSupport::TestCase
  self.use_transactional_fixtures = true

  test "User must be invalid" do
    user = User.new
    assert_not user.valid?, user.errors.messages
  end

  test "Must raise exception. Invalid record" do
    user = User.new
    assert_raise ActiveRecord::RecordInvalid do
      user.save!
    end
  end

  test "User must be invalid. Invalid email" do
    user = User.new(full_name: "jobs",
                    email: "jobs@apple",
                    password: "123")

    user1 = User.new(full_name: "jobs",
                    email: "jobs@",
                    password: "123")
    assert_not user.valid?, "User validation should be false"
    assert user.errors.messages.has_key?(:email), "Errors messages should contains :email key"
    assert_not user1.valid?, "User validation should be false"
  end

  test "User must be invalid. Full name attribute isn't filled in" do
    user = User.new(full_name: nil,
                    email: "jobs@apple.com",
                    password: "123")
    assert_not user.valid?,  "User validation should be false"
    assert user.errors.messages.has_key?(:full_name), "Errors messages should contains :full_name key"
  end

  test "User must be invalid. Email attribute isn't filled in" do
    user = User.new(full_name: "jobs",
                    email: nil,
                    password: "123")
    assert_not user.valid?, "User validation should be false"
    assert user.errors.messages.has_key?(:email), "Errors messages should contains :email key"
  end

  test "User must be invalid. Password attribute isn't filled in" do
    user = User.new(full_name: "jobs",
                    email: "jobs@apple.com",
                    password: nil)
    assert_not user.valid?, "User validation should be false"
    assert user.errors.messages.has_key?(:password), "Errors messages should contains :passowrd key"
  end

  test "User must be invalid. Full name length attribute isn't valid. 
      Full name must have between 2 to 70 characters" do
    user = User.new(full_name: "j",
                    email: "jobs@apple.com",
                    password: "123")
    assert_not user.valid?, "User validation should be false"
    assert user.errors.messages.has_key?(:full_name), "Errors messages should contains :full_name key"
  end

  test "User must be invalid. Email length attribute isn't valid. 
      Email must have between 5 to 70 characters" do
    user = User.new(full_name: "jobs",
                    email: "j@a",
                    password: "123")
    assert_not user.valid?, "User validation should be false"
    assert user.errors.messages.has_key?(:email), "Errors messages should contains :email key"
  end

  test "User must be invalid. Password length attribute isn't valid. 
      Password must have between 3 to 10 characters" do
    user_less_password_length = User.new(full_name: "jobs",
                    email: "jobs@apple.com",
                    password: "12")
    user_greater_than_password_length = User.new(full_name: "jobs",
                    email: "jobs@apple.com",
                    password: "12345678900")
    assert_not user_less_password_length.valid?, "User validation should be false"
    assert user_less_password_length.errors.messages.has_key?(:password), "Errors messages should contains :password key"
    assert_not user_greater_than_password_length.valid?, "User validation should be false"
    assert user_greater_than_password_length.errors.messages.has_key?(:password), "Errors messages should contains :password key"
  end

  test "User invalid and doesn't must be saved. Duplicate user/email." do
    user = User.new(full_name: users(:vinicius).full_name,
                    email: users(:vinicius).email,
                    password: "123")
    assert_not user.valid?, "User validation should be false"
    assert user.errors.messages.has_key?(:email), "Errors messages should contains :email key"
  end

  test "User must be valid" do
    user = User.new(full_name: "jobs",
                    email: "jobs@apple.com",
                    password: "123")
    assert user.valid?, "User validation should be true"
    assert user.errors.messages.empty?, "Shouldn't contains any error message elements"
  end


  test "User is valid and must be save " do
    user = User.new(full_name: "fulano",
                    email: "fulano@email.com",
                    password: "123")
    assert user.valid?, "User validation should be true"
    assert user.errors.messages.empty?, "Shouldn't contains any error message elements"
    assert user.save!, "User should be saved and return true"
  end

  test "Find user by id" do
    user = User.find(2)
    assert_equal user.email, users(:joao).email
  end
end
