class User < ApplicationRecord
  attr_accessor :activation_token
  before_save :dowcase_email
  before_create :create_activaion_digest

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, format: {with: VALID_EMAIL_REGEX, message: :email_fomat}
  validates :email, length: {maximum: Settings.user.mail_length, message: :too_long}
  validates :email, presence: {message: :cant_blank}
  validates :email, uniqueness: {case_sensitive: false, message: :taken}
  validates :name, length: {maximum: Settings.user.name_length, message: :too_long}
  validates :name, presence: {message: :cant_blank}
  validates :password, length: {minimum: Settings.user.min_pass, message: :too_short}
  validates :password, presence: {message: :cant_blank}

  before_save :dowcase_email

  has_secure_password

  scope :except_ids, ->(ids){where.not id: ids}
  scope :activated, ->{where activated: true}

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  private
  def dowcase_email
    self.email = email.downcase
  end

  def create_activaion_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
