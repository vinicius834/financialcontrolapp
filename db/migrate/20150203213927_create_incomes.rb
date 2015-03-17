class CreateIncomes < ActiveRecord::Migration
  def change
    create_table :incomes do |t|
      t.string :description
      t.date :date
      t.money :value

      t.timestamps
    end
  end
end
