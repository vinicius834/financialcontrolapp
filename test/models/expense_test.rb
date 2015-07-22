require 'test_helper'

class ExpenseTest < ActiveSupport::TestCase

  test "Expense must be invalid" do
    expense = Expense.new
    assert_not expense.valid?, expense.errors.messages
  end

  test "Must raise exception. Invalid record" do
    expense = Expense.new
    assert_raise ActiveRecord::RecordInvalid do
      expense.save!
    end
  end

  test "Expense must be invalid. Description attribute isn't filled in" do
    expense = Expense.new(description: nil,
                          value_cents: 32,
                          expiration_date: Date.new(2012,3,31),
                          paid: false,
                          user_id: 1)
    assert_not expense.valid?, "Expense validation should be false"
    assert expense.errors.messages.has_key?(:description), "Errors messages should contains :description key"
  end

  test "Expense must be invalid. Value cents attribute isn't filled in" do
    expense = Expense.new(description: "Credit card",
                        value_cents: nil,
                        expiration_date: Date.new(2012,3,31),
                        paid: false,
                        user_id: 1)
   assert_not expense.valid?, "Expense validation should be false"
   assert expense.errors.messages.has_key?(:value_cents), "Errors messages should contains :value_cents key"
  end

  test "Expense must be invalid. Expiration date attribute isn't filled in" do
    expense = Expense.new(description: "Credit card",
                        value_cents: 1000,
                        expiration_date: nil,
                        paid: false,
                        user_id: 1)
    assert_not expense.valid?, "Expense validation should be false"
    assert expense.errors.messages.has_key?(:expiration_date), "Errors messages should contains :expiration_date key"  end

  test "Expense must be invalid. User_id attribute isn't filled in" do
    expense = Expense.new(description: "Credit card",
                        value_cents: 1000,
                        expiration_date: Date.new(2012,3,31),
                        paid: false,
                        user_id: nil)
    assert_not expense.valid?, "Expense validation should be false"
    assert expense.errors.messages.has_key?(:user_id), "Errors messages should contains :user_id key"
  end

  test "Expense must be invalid. Description length attribute isn't valid. 
      Description must have between 3 to 70 characters" do
    expense_min_length_description = Expense.new(description: "R",
                                   value_cents: 1000,
                                   expiration_date: Date.new(2012,3,31),
                                   user_id: 1)
    expense_max_length_description = Expense.new(description: "edededeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee",
                                  value_cents: 1000,
                                  expiration_date: Date.new(2012,3,31),
                                  paid: false,
                                  user_id: 1)
    assert_not expense_min_length_description.valid?, "Expense validation should be false"
    assert expense_min_length_description.errors.messages.has_key?(:description), "Errors messages should contains :description key"
    assert_not expense_max_length_description.valid?, "Expense validation should be false"
    assert expense_max_length_description.errors.messages.has_key?(:description), "Errors messages should contains :description key"
  end

  test "Expense must be invalid. Value cents attribute is less than zero. 
      Value cents must be greater or equal 0(zero)" do
    expense = Expense.new(description: "Rent credit",
                        value_cents: -1,
                        expiration_date: Date.new(2012,3,31),
                        paid: true,
                        user_id: 1)
    assert_not expense.valid?, "Expense validation should be false"
    assert expense.errors.messages.has_key?(:value_cents), "Errors messages should contains :value_cents key"
  end

  test "Expense must be invalid. User not found." do
    expense = Expense.new(description: "Rent credit",
                        value_cents: 1200,
                        expiration_date: Date.new(2012,3,31),
                        paid: true,
                        user_id: -1)
    assert_not expense.valid?, "Expense validation should be false"
    assert expense.errors.messages.has_key?(:user), "Errors messages should contains :user key"
  end

  test "Expense must be valid and must be save" do
    expense = Expense.new(description: "Rent credit",
                        value_cents: 1200,
                        expiration_date: Date.new(2012,3,31),
                        paid: true,
                        user_id: 1)
    assert expense.valid?, "Expense validation should be true"
    assert expense.errors.messages.empty?, "Shouldn't contains any error message elements"
    assert expense.save!, "Expense should be saved and return true"
  end
end
