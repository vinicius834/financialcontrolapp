class Expense < ActiveRecord::Base
  validates_presence_of :description, :expiration_date, :value_cents
  monetize :value_cents
  belongs_to :user
end
