class Income < ActiveRecord::Base
  extend Functions
  belongs_to :user
  validates :user_id, presence: true
  validates :value_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true, length: { in: 3..70 }
  validates :date, presence: true
  validates :user, presence: true, allow_nil: false, allow_blank: false
  monetize :value_cents

  def self.find_incomes_by_range_dates(current_user, from, to)
    return [] if (from.empty? && to.empty?)

    if (!from.empty? && to.empty?)
      current_user.incomes.where("date >= :from", { from: Date.parse(from) })
    elsif (from.empty? && !to.empty?)
      current_user.incomes.where("date <= :to", { to: Date.parse(to) })
    else
      current_user.incomes.where(date: date_range(from, to))
    end
  end

  def self.incomes_total_calculate(incomes)
    incomes.inject(0) { |total, income| total + income.value } 
  end
end
