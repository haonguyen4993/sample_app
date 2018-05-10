class User < ApplicationRecord
  # constants
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # validations
  validates :email, format: {with: VALID_EMAIL_REGEX, message: :email_fomat}
  validates :email, length: {maximum: Settings.user.mail_length, message: :too_long}
  validates :email, presence: {message: :cant_blank}
  validates :email, uniqueness: {case_sensitive: false, message: :taken}
  validates :name, length: {maximum: Settings.user.name_length, message: :too_long}
  validates :name, presence: {message: :cant_blank}
  validates :password, length: {minimum: Settings.user.min_pass, message: :too_short}
  validates :password, presence: {message: :cant_blank}

  # callback macro
  before_save :dowcase_email

  has_secure_password

  def dowcase_email
    self.email = email.downcase
  end
end
