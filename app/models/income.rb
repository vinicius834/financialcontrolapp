class Income < ActiveRecord::Base
  belongs_to :user
  validates :value_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true, length: { in: 3..70 }
  validates :date, presence: true
  validates :user, presence: true, allow_nil: false, allow_blank: false
  monetize :value_cents  
end