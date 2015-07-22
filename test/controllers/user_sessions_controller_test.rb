class UserSessionsControllerTest < ActionController::TestCase
=begin
  test "Must render new template." do
    get(:new)
    assert_template :new
    assert_response :success
  end
  
  test "Must not create a session. Email is invalid." do
    post(:create, user_session: {email: "test", password: "123"})
    assert_template :new
  end
  
  test "Must not create a session. Password is invalid." do
    post(:create, user_session: {email: users(:vinicius).email, password: "12666"})
    assert_template :new
  end
  
  test "Must create a session" do
    post(:create, user_session: {email: users(:vinicius).email, password: "123"})
    assert_equal users(:vinicius), assigns(:user_session).current_user
    assert_redirected_to root_path
  end
  
  test "Must destroy a session" do
    delete(:destroy)
    assert_redirected_to new_user_sessions_path
  end
=end
end
