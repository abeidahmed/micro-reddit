class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  before_validation :normalize_email_address

  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :full_name, presence: true, length: { maximum: 255 }
  validates(
    :email_address,
    presence: true,
    length: { maximum: 255 },
    uniqueness: { case_sensitive: false },
    format: { with: VALID_EMAIL_REGEX }
  )
  validates :password, length: { minimum: 6 }

  private

  def normalize_email_address
    self.email_address = email_address.to_s.strip.downcase
  end
end
