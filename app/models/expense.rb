class Expense < ActiveRecord::Base
  extend Functions
  belongs_to :user
  validates :value_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true, length: { in: 3..70 }
  validates :expiration_date, presence: true
  validates :user, presence: true, allow_nil: false, allow_blank: false
  monetize :value_cents

  def self.find_expenses_by_range_dates(current_user, from, to)
  
    if (from.empty? && to.empty?)
      []
    elsif (!from.empty? && to.empty?)
      current_user.expenses.where("expiration_date >= :from", 
          { from: Date.parse(from) })
    elsif (from.empty? && !to.empty?)
      current_user.expenses.where("expiration_date <= :to", 
          { to: Date.parse(to) })
    else
      current_user.expenses.where(expiration_date: date_range(from, to))  
    end
  end

  def self.expenses_total_calculate(expenses)
    expenses.inject(0) { |total, expense| total + expense.value } 
  end
end
