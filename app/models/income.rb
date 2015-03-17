class Income < ActiveRecord::Base
  validates_presence_of :description, :value_cents, :date
  monetize :value_cents    
  belongs_to :user
end