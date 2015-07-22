require 'test_helper'

class IncomeTest < ActiveSupport::TestCase

  test "Income must be invalid" do
    income = Income.new
    assert_not income.valid?
  end

  test "Must raise exception. Invalid record" do
    income = Income.new
    assert_raise ActiveRecord::RecordInvalid do
      income.save!
    end
  end

  test "Income must be invalid. Description attribute isn't filled in" do
    income = Income.new(description: nil,
                        value_cents: 32,
                        date: Date.new(2012,3,31),
                        user_id: 1)
    assert_not income.valid?, "Income validation should be false"
    assert income.errors.messages.has_key?(:description), "Errors messages should contains :description key"
  end

  test "Income must be invalid. Value cents attribute isn't filled in" do
    income = Income.new(description: "Rent credit",
                        value_cents: nil,
                        date: Date.new(2012,3,31),
                        user_id: 1)
    assert_not income.valid?, "Income validation should be false"
    assert income.errors.messages.has_key?(:value_cents), "Errors messages should contains :value_cents key"
  end

  test "Income must be invalid. Date attribute isn't filled in" do
    income = Income.new(description: "Rent credit",
                        value_cents: 1000,
                        date: nil,
                        user_id: 1)
    assert_not income.valid?, "Income validation should be false"
    assert income.errors.messages.has_key?(:date), "Errors messages should contains :date key"
  end

  test "Income must be invalid. User_id attribute isn't filled in" do
    income = Income.new(description: "Rent credit",
                        value_cents: 1000,
                        date: Date.new(2012,3,31),
                        user_id: nil)
    assert_not income.valid?, "Income validation should be false"
    assert income.errors.messages.has_key?(:user_id), "Errors messages should contains :user_id key"
  end

  test "Income must be invalid. Description length attribute isn't valid. 
      Description must have between 3 to 70 characters" do
    income_min_length = Income.new(description: "R",
                                   value_cents: 1000,
                                   date: Date.new(2012,3,31),
                                   user_id: 1)
    income_max_length = Income.new(description: "edededeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee",
                                   value_cents: 1000,
                                   date: Date.new(2012,3,31),
                                   user_id: 1)
    assert_not income_min_length.valid?, "Income validation should be false"
    assert income_min_length.errors.messages.has_key?(:description), "Errors messages should contains :description key"
    assert_not income_max_length.valid?, "Income validation should be false"
    assert income_max_length.errors.messages.has_key?(:description), "Errors messages should contains :description key"

  end

  test "Income must be invalid. Value cents attribute is less than zero. 
      Value cents must be greater or equal 0(zero)" do
    income = Income.new(description: "Rent credit",
                        value_cents: -1,
                        date: Date.new(2012,3,31),
                        user_id: 1)
    assert_not income.valid?, "Income validation should be false"
    assert income.errors.messages.has_key?(:value_cents), "Errors messages should contains :value_cents key"
  end

  test "Icome must be invalid. User not found." do
    income = Income.new(description: "Rent credit",
                        value_cents: 1200,
                        date: Date.new(2012,3,31),
                        user_id: -1)
    assert_not income.valid?, "Income validation should be false"
    assert income.errors.messages.has_key?(:user), "Errors messages should contains :user key"
  end

  test "Icome must be valid and must be save" do
    income = Income.new(description: "Rent credit",
                        value_cents: 1200,
                        date: Date.new(2012,3,31),
                        user_id: 1)
    assert income.valid?, "Income validation should be true"
    assert income.errors.messages.empty?, "Shouldn't contains any error message elements"
    assert income.save!, "Income should be saved and return true"
  end
end
