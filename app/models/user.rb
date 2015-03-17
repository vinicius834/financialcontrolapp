class User < ActiveRecord::Base
  validates_presence_of :email, :full_name
  validates_uniqueness_of :email, message: 'already exists.'
  
  has_many :incomes, dependent: :destroy
  has_many :expenses, dependent: :destroy

  has_secure_password
  
  scope :confirmed, -> { where.not(confirmed_date: nil) }
  
  before_create do |user|
    user.confirmation_token = SecureRandom.urlsafe_base64
  end

  def confirm!
  	return if confirmed?
    self.confirmed_date = Time.current
    self.confirmation_token = ''
    save!
  end
  
  def confirmed?
    confirmed_date.present?
  end

  def self.authenticate(email, password)
    confirmed.find_by(email: email).try(:authenticate, password)
  end
end