class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :validatable

  validates :full_name, length: { in: 2..70 }, presence: true

  has_many :incomes, dependent: :destroy
  has_many :expenses, dependent: :destroy

end
