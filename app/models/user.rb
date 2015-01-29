class User < ActiveRecord::Base  
  before_save { self.email = email.downcase }
  before_create :create_remember_token

  has_many :listings

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates_presence_of :password, :on => :create
  validates :password, length: { minimum: 6 }, :if => :password_present?

  mount_uploader :avatar, ImageUploader

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end 

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

    def password_present?
      password.present? || password_confirmation.present?
    end
end
