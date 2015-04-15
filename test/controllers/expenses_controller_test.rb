class ExpensesControllerTest < ActionController::TestCase
  
  setup do 
    @vinicius = users(:vinicius)
    @expense = expenses(:energy)
    login
  end
  
  teardown do
    @vinicius = nil
    @user_session.destroy
  end
  
  test "Must return an empty expense and render new template" do
    get(:new)
    assert assigns(:expense).description.nil?
    assert_not (:expense).nil?
    assert_template :new
  end
 
  test "Must return the expense and render edit template" do
    get(:edit, id: @expense.id)
    assert assigns(:expense)
    assert_equal assigns(:expense).description, @expense.description
    assert_response :success
  end
 
  test "Must not create and must render new template. Description attribute isn't filled in" do
    post(:create, expense: {description: nil,
                            value: "32",
                            expiration_date: Date.new(2012,3,31),
                            paid: false,
                            user_id: @vinicius.id})
    assert_template :new
  end

  test "Must not create and must render new template. Value attribute isn't filled in" do
    post(:create, expense: {description: "health care",
                            value: "",
                            expiration_date: Date.new(2012,3,31),
                            paid: false,
                            user_id: @vinicius.id})
    assert_template :new
  end

  test "Must not create and must render new template. Expiration date attribute isn't filled in" do
    post(:create, expense: {description: "health care",
                            value: "20000",
                            expiration_date: nil,
                            paid: false,
                            user_id: @vinicius.id})
    assert_template :new
  end

  test "Must not create and must redirect to login. User isn't logged in" do
    @user_session.destroy
    post(:create, expense: {description: "health care",
                            value: "20000",
                            expiration_date: Date.new(2012,3,31),
                            paid: false,
                            user_id: nil})
    assert_redirected_to new_user_sessions_path
  end
  
  test "Must not create and must render new template. Description length attribute isn't valid. 
      Description must have between 3 to 70 characters" do
    post(:create, expense: {description: "ye",
                            value: "20000",
                            expiration_date: Date.new(2012,3,31),
                            paid: false,
                            user_id: nil})
    assert_template :new
    post(:create, expense: {description: "edededeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee",
                            value: "20000",
                            expiration_date: Date.new(2012,3,31),
                            paid: false,
                            user_id: @vinicius.id})
    assert_template :new
  end

  test "Must not create and must render new template. Value attribute can't be less than zero." do
    post(:create, expense: {description: "health care",
                           value: "-1",
                           expiration_date: Date.new(2012,3,31),
                           paid: false,
                           user_id: @vinicius.id})
    assert_template :new
  end

  test "Must create and must must redirect to root path." do
    post(:create, expense: {description: "health care",
                            value: "500",
                            expiration_date: Date.new(2012,3,31),
                            paid: false,
                            user_id: @vinicius.id})
    assert_redirected_to root_path
  end
  
  test "Must create and must must redirect to root path. Paid equal true" do
    post(:create, expense: {description: "health care",
                            value: "500",
                            expiration_date: Date.new(2012,3,31),
                            paid: true,
                            user_id: @vinicius.id})
    assert_redirected_to root_path
    assert assigns(:expense).paid
  end

  test "Must not update and must render edit template. Description attribute isn't filled in" do
    put(:update, id: @expense.id, expense: {description: "",
                                            value: "500",
                                            expiration_date: Date.new(2012,3,31),
                                            paid: false,
                                            user_id: @vinicius.id})
    assert_template :edit
  end

  test "Must not update and must render edit template. Value attribute isn't filled in" do
    put(:update, id: @expense.id, expense: {description: "health care",
                                            value: "",
                                            expiration_date: Date.new(2012,3,31),
                                            paid: false,
                                            user_id: @vinicius.id})
    assert_template :edit
  end

  test "Must not update and must render edit template. Expiration date attribute isn't filled in" do
    put(:update, id: @expense.id, expense: {description: "health care",
                                            value: "500",
                                            expiration_date: nil,
                                            paid: false,
                                            user_id: @vinicius.id})
  end
 
  test "Must not update and must redirect to login. User isn't logged in" do
    @user_session.destroy
    put(:update, id: @expense.id, expense: {description: "health care",
                                            value: "500",
                                            expiration_date: Date.new(2012,3,31),
                                            paid: false,
                                            user_id: nil})
    assert_redirected_to new_user_sessions_path
  end

  test "Must not update and must render edit template. Description length attribute isn't valid. 
      Description must have between 3 to 70 characters" do
    put(:update, id: @expense.id, expense: {description: "sa",
                                            value: "500",
                                            expiration_date: Date.new(2012,3,31),
                                            paid: false,
                                            user_id: @vinicius.id})
    assert_template :edit
    put(:update, id: @expense.id, expense: {description:  "edededeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee",
                                            value: "500",
                                            expiration_date: Date.new(2012,3,31),
                                            paid: false,
                                            user_id: @vinicius.id})
    assert_template :edit
  end

  test "Must not update and must render edit template. Value attribute can't be less than zero." do
    put(:update, id: @expense.id, expense: {description: @expense.description,
                                            value: "",
                                            expiration_date: Date.new(2012,3,31),
                                            paid: false,
                                            user_id: @vinicius.id})
    assert_template :edit
  end

  test "Must update the expense and must must redirect to root path." do
    put(:update, id: @expense.id, expense: {description: @expense.description,
                                            value: "200",
                                            expiration_date: Date.new(2012,3,31),
                                            paid: false,
                                            user_id: @vinicius.id})
    assert_redirected_to root_path
  end

  test "Must destroy the expense" do
    delete(:destroy, id: @expense.id)
    assert_redirected_to root_path
    assert_raise ActiveRecord::RecordNotFound do
      @user_session.current_user.expenses.find(@expense.id)
    end
  end

  test "Must return a list with expenses" do
    $total_incomes = 0
    $total_expenses = 0
    xhr(:get, :search_between_dates, from_date_expense: '2015-02-03', to_date_expense: '2015-02-06')
    assert_not_empty assigns(:expenses)
  end

  test "Must return a list with all incomes" do
    $total_incomes = 0
    $total_expenses = 0
    xhr(:get, :all, from_date_expense: '2015-02-03', to_date_expense: '2015-02-06')
    assert_equal assigns(:expenses), Expense.all
  end
 
  private

  def login
    @user_session = UserSession.new(session, {email: @vinicius.email, password: "123"})
    @user_session.authenticate!
  end
end