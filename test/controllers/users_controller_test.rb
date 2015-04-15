class UsersControllerTest < ActionController::TestCase
  
  setup do
    @vinicius = users(:vinicius)  
    login
  end
  
  teardown do
    @vinicius = nil
    @user_session.destroy
  end
  
  test "Must return user and render new template" do
    get(:new)
    assert assigns(:user)
    assert_template :new
  end
  
  test "Must return user and render edit template" do
    get(:edit, id: @vinicius)
    assert assigns(:user)
    assert_equal assigns(:user).full_name, @vinicius.full_name
    assert_response :success
  end
  
  test "Must not create and must render new template. Full name attribute isn't filled in" do
    post(:create, user: {full_name: "",
                         email: "vini@gmail.com",
                         password: "123",
                         password_confirmation: "123"})
    assert_template :new
  end
  
  test "Must not create and must render new template. Email attribute isn't filled in" do
    post(:create, user: {full_name: "vinicius",
                         email: "",
                         password: "123",
                         password_confirmation: "123"})
    assert_template :new
  end
  
  test "Must not create and must  render new template. Password attribute isn't filled in" do
    post(:create, user: {full_name: "vinicius",
                         email: "vini@gmail.com",
                         password: "",
                         password_confirmation: "123"})
    assert_template :new
  end
  
  test "Must not create and must render new template. Password confirmation attribute isn't filled in" do
    post(:create, user: {full_name: "vinicius",
                         email: "vini@gmail.com",
                         password: "123",
                         password_confirmation: ""})
    assert_template :new
  end
  
  test "Must not create and must render new template. Full name length attribute isn't valid. 
      Full name must have between 2 to 70 characters" do
    post(:create, user: {full_name: "v",
                         email: "vini@gmail.com",
                         password: "123",
                         password_confirmation: "123"})
    assert_template :new
    post(:create, user: {full_name: "edededeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee",
                         email: "vini@gmail.com",
                         password: "123",
                         password_confirmation: "123"})
    assert_template :new    
  end
  
  test "Must not create and must render new template. Email length attribute isn't valid. 
      Email must have between 5 to 70 characters" do
    post(:create, user: {full_name: "vinicius",
                         email: "v@l.c",
                         password: "123",
                         password_confirmation: "123"})
    assert_template :new
    post(:create, user: {full_name: "vinicius",
                         email: "edededeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee@gmail.com",
                         password: "123",
                         password_confirmation: "123"})
    assert_template :new    
  end
  
  test "Must not create and must render new template. Password length attribute isn't valid. 
      Password must have between 3 to 10 characters" do
    post(:create, user: {full_name: "vinicius",
                         email: "vini@gmail.com",
                         password: "12",
                         password_confirmation: "12"})
    assert_template :new
    post(:create, user: {full_name: "vinicius",
                         email: "edededeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee@gmail.com",
                         password: "12",
                         password_confirmation: "12"})
    assert_template :new    
  end
  
  test "Must not create and must render new template. Password confirmation is different." do
    post(:create, user: {full_name: "vinicius",
                         email: "vini@gmail.com",
                         password: "123",
                         password_confirmation: "124"})
    assert_template :new
    post(:create, user: {full_name: "vinicius",
                         email: "edededeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee@gmail.com",
                         password: "123",
                         password_confirmation: "124"})
    assert_template :new    
  end
  
  test "Must not create and must render new template. Duplicate email" do
    post(:create, user: {full_name: "vinicius souza",
                         email: users(:vinicius).email,
                         password: "123",
                         password_confirmation: "123"})
    assert_template :new
  end
  
  test "Must create and redirect to login" do
    post(:create, user: {full_name: "vinicius souza",
                         email: "vini_souza@email.com",
                         password: "123",
                         password_confirmation: "123"})
    assert_redirected_to new_user_sessions_path
  end
  
  test "Must update and redirect to root path" do
    put(:update, id: @vinicius.id, user: {full_name: "vinicius souza",
                                          email: "vini_souza@email.com"})
    assert_redirected_to root_path
  end
  
  private
  
  def login
    @user_session = UserSession.new(session, {email: @vinicius.email, password: "123"})
    @user_session.authenticate!
  end
end