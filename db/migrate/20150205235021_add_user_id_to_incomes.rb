class AddUserIdToIncomes < ActiveRecord::Migration
  def change
    add_reference :incomes, :user, index: true
  end
end
