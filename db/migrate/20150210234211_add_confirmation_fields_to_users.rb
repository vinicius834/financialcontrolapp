class AddConfirmationFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :confirmed_date, :datetime
    add_column :users, :confirmation_token, :string
  end
end
