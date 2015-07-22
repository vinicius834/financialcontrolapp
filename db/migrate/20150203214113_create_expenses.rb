class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :description
      t.date :expiration_date
      t.money :value
      t.boolean :paid
      t.timestamps
    end
  end
end
