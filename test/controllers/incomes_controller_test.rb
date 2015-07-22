class IncomesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    request.env["devise.mapping"] = Devise.mappings[:user]
    @user = users(:vinicius)
    @income = incomes(:salary)
    sign_in @user
  end

  test "Must return an empty income and render new template" do
    get :new
    assert_template :new, "Should render new template"
  end
  test "Must return the income and render edit template" do
    get(:edit, id: @income.id)
    assert_equal assigns(:income).description, @income.description
    assert_template :edit, "Should render new template"
  end

  test "Must not create and must render new template. Description attribute isn't filled in" do
    post(:create, income: {description: nil,
                           value: "32,00",
                           date: Date.new(2012,3,31),
                           user_id: @user.id})
    assert_template :new, "Should render new template"
  end

  test "Must not create and must render new template. Value attribute isn't filled in" do
    post(:create, income: {description: "yearly bonus",
                           value: "",
                           date: Date.new(2012,3,31),
                           user_id: @user.id})
    assert_template :new, "Should render new template"
  end

  test "Must not create and must render new template. Date attribute isn't filled in" do
    post(:create, income: {description: "yearly bonus",
                           value: "1.000,00",
                           date: nil,
                           user_id: @user.id})
    assert_template :new, "Should render new template"
  end

  test "Must not create and must redirect to login. User isn't logged in" do
    sign_out @user
    post(:create, income: {description: "yearly bonus",
                           value: "1.000,00",
                           date: Date.new(2012,3,31),
                           user_id: nil})
    assert_redirected_to new_user_session_path, "Should redirect to log in"
  end

  test "Must not create and must render new template. Description length attribute isn't valid. 
      Description must have between 3 to 70 characters" do
    post(:create, income: {description: "ye",
                           value: "1.000,00",
                           date: Date.new(2012,3,31),
                           user_id: @user.id})
    assert_template :new, "Should render new template"
    post(:create, income: {description: "edededeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee",
                           value: "1.000,00",
                           date: Date.new(2012,3,31),
                           user_id: @user.id})
    assert_template :new, "Should render new template"
  end

  test "Must not create and must render new template. Value attribute can't be less than zero." do
    post(:create, income: {description: "yearly bonus",
                           value: "-1",
                           date: Date.new(2012,3,31),
                           user_id: @user.id})
    assert_template :new, "Should render new template"
  end

  test "Must create and must must redirect to root path." do
    post(:create, income: {description: "yearly bonus",
                           value: "1.000,00",
                           date: Date.new(2012,3,31),
                           user_id: @user.id})
    assert_redirected_to root_path, "Should redirect to root path"
  end

  test "Must not update and must render edit template. Description attribute isn't filled in" do
    put(:update, id: @income.id, income: {description: "",
                                          value: @income.value.to_s,
                                          date: Date.new(2012,3,31),
                                          user_id: @user.id})
    assert_template :edit, "Should render edit template"
  end

  test "Must not update and must render edit template. Value attribute isn't filled in" do
    put(:update, id: @income.id, income: {description: @income.description,
                                          value: "",
                                          date: Date.new(2012,3,31),
                                          user_id: @user.id})
    assert_template :edit, "Should render edit template"
  end


  test "Must not update and must render edit template. Date attribute isn't filled in" do
    put(:update, id: @income.id, income: {description: @income.description,
                                          value: @income.value.to_s,
                                          date: nil,
                                          user_id: @user.id})
    assert_template :edit, "Should render edit template"
  end

  test "Must not update and must redirect to login. User isn't logged in" do
    sign_out @user
    put(:update, id: @income.id, income: {description: @income.description,
                                          value: @income.value.to_s,
                                          date: Date.new(2012,3,31),
                                          user_id: nil})
    assert_redirected_to new_user_session_path, "Should redirect to log in"
  end

  test "Must not update and must render edit template. Description length attribute isn't valid. 
      Description must have between 3 to 70 characters" do
    put(:update, id: @income.id, income: {description: "sa",
                                          value: @income.value.to_s,
                                          date: Date.new(2012,3,31),
                                          user_id: @user.id})
    assert_template :edit, "Should render edit template"
    put(:update, id: @income.id, income: {description:  "edededeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee",
                                          value: @income.value.to_s,
                                          date: Date.new(2012,3,31),
                                          user_id: @user.id})
    assert_template :edit, "Should render edit template"
  end

  test "Must not update and must render edit template. Value attribute can't be less than zero." do
    put(:update, id: @income.id, income: {description: @income.description,
                                          value: "-1",
                                          date: Date.new(2012,3,31),
                                          user_id: nil})
    assert_template :edit, "Should render edit template"
  end

  test "Must update the income and must must redirect to root path." do
     put(:update, id: @income.id, income: {description: @income.description,
                                           value: "2.000,00",
                                           date: Date.new(2012,3,31),
                                           user_id: @user.id})
    assert_redirected_to root_path, "Should redirect to root path"
  end

  test "Must destroy the income" do
    delete(:destroy, id: @income.id)
    assert_redirected_to root_path
    assert_raise ActiveRecord::RecordNotFound do
      @user.incomes.find(@income.id)
    end
  end

  test "Must return a list with incomes" do
    $total_incomes = 0
    $total_expenses = 0
    xhr(:get, :search_between_dates, from_date_income: '2015-02-03', to_date_income: '2015-02-06')
    assert_not_empty assigns(:incomes), "Expense shouldn't be empty"
  end

  test "Must return a list with all incomes" do
    $total_incomes = 0
    $total_expenses = 0
    xhr(:get, :all, from_date_income: '2015-02-03', to_date_income: '2015-02-06')
    assert_equal assigns(:incomes), Income.all
  end
end
