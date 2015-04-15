class Income < ActiveRecord::Base
  validates_presence_of :description, :value_cents, :date
  validates :value_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :description, length: { in: 3..70 }

  monetize :value_cents  
  
  belongs_to :user
  validates :user, presence: true, allow_nil: false, allow_blank: false
end