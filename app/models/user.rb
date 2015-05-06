class User < ActiveRecord::Base
  EMAIL_REGEXP = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  
  validates :email, presence: true,  format: {with: EMAIL_REGEXP}, uniqueness: {message: 'already exists.'}, length: { in: 6..70 }
  validates :full_name, length: { in: 2..70 }, presence: true
  validates :password, presence: { on: create }, length: { in: 3..10, allow_blank: true }
  
  has_many :incomes, dependent: :destroy
  has_many :expenses, dependent: :destroy

  has_secure_password
  
  scope :confirmed, -> { where.not(confirmed_date: nil) }
  
  before_create do |user|
    user.confirmation_token = generate_token
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
    
  def send_password_reset  
    self. password_reset_token = generate_token
    self.password_reset_sent_at = Time.zone.now  
    save!  
    UserMailer.password_reset(self).deliver  
  end 
    
  def generate_token
    SecureRandom.urlsafe_base64  
  end
end