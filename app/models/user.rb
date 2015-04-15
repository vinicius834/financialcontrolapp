class User < ActiveRecord::Base
  EMAIL_REGEXP = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  
  validates_presence_of :email, :full_name
  validates_uniqueness_of :email, message: 'already exists.'
  validates :email, length: { in: 6..70 }
  validates :full_name, length: { in: 2..70 }
  validates :password, presence: { on: create }, length: { in: 3..10, allow_blank: true }
  validates_format_of  :email, with: EMAIL_REGEXP
  
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