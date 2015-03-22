class Expense < ActiveRecord::Base
  validates_presence_of :description, :expiration_date, :value_cents
  validates :value_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :description, length: { in: 3..70 }
  monetize :value_cents
  belongs_to :user
end
