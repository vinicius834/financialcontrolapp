require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  tests Registrations::RegistrationsController
  include Devise::TestHelpers

  setup do
    request.env["devise.mapping"] = Devise.mappings[:user]
    @vinicius = users(:vinicius)
  end

  test "Must return user and render new template" do
    get :new
    assert assigns :user
    assert_response :success
    assert_template :new, "Must render new template"
  end

  test "Must return user and render edit template" do
    sign_in @vinicius
    get(:edit)
    assert_equal assigns(:user).full_name, @vinicius.full_name
    assert_template :edit, "Must render edit template"
  end

  test "Must not create and must render new template. Full name attribute isn't filled in" do
    post(:create, user: {full_name: nil,
                         email: "vini@gmail.com",
                         password: "123",
                         password_confirmation: "123"})
    assert_template :new, "Must render new template"
  end

  test "Must not create and must render new template. Email attribute isn't filled in" do
    post(:create, user: {full_name: "vinicius",
                         email: "",
                         password: "123",
                         password_confirmation: "123"})
    assert_template :new
  end

  test "Must not create and must render new template. Password attribute isn't filled in" do
    post(:create, user: {full_name: "vinicius",
                         email: "vini@gmail.com",
                         password: "",
                         password_confirmation: "123"})
    assert_template :new, "Must render new template"
  end


  test "Must not create and must render new template. Password confirmation attribute isn't filled in" do
    post(:create, user: {full_name: "vinicius",
                         email: "vini@gmail.com",
                         password: "123",
                         password_confirmation: ""})
    assert_template :new, "Must render new template"
  end

  test "Must not create and must render new template. Full name length attribute isn't valid. 
      Full name must have between 2 to 70 characters" do
    post(:create, user: {full_name: "v",
                         email: "vini@gmail.com",
                         password: "123",
                         password_confirmation: "123"})
    assert_template :new, "Must render new template"

    post(:create, user: {full_name: "edededeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee",
                         email: "vini@gmail.com",
                         password: "123",
                         password_confirmation: "123"})
    assert_template :new, "Must render new template"
  end

  test "Must not create and must render new template. Password length attribute isn't valid. 
      Password must have between 3 to 10 characters" do
    post(:create, user: {full_name: "vinicius",
                         email: "vini@gmail.com",
                         password: "12",
                         password_confirmation: "12"})
    assert_template :new, "Must render new template"
    post(:create, user: {full_name: "vinicius",
                         email: "edededeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee@gmail.com",
                         password: "12",
                         password_confirmation: "12"})
    assert_template :new, "Must render new template"
  end

  test "Must not create and must render new template. Password confirmation is different." do
    post(:create, user: {full_name: "vinicius",
                         email: "vini@gmail.com",
                         password: "123",
                         password_confirmation: "124"})
    assert_template :new, "Must render new template"
  end

  test "Must not create and must render new template. Duplicate email" do
    post(:create, user: {full_name: "vinicius souza",
                         email: users(:vinicius).email,
                         password: "123",
                         password_confirmation: "123"})
    assert_template :new, "Must render new template"
  end

  test "Must create and redirect to log in" do
    post(:create, user: {full_name: "vinicius souza",
                         email: "vini_souza@email.com",
                         password: "123",
                         password_confirmation: "123"})
    assert_redirected_to new_user_session_path
  end

  test "Must update" do
    sign_in @vinicius
    put(:update, user: {full_name: "vinicius souza",
                        email: "vini_souza@email.com"})
    assert_response :success
  end
end
