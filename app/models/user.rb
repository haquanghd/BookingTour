class User < ApplicationRecord
  before_save :default_admin
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: Settings.size.length_max_name}
  validates :email, presence: true, length: {maximum: Settings.size.length_max_255},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.size.min_password}, allow_nil: true
  validates :phone, presence: true
  validates :address, presence: true, length: {maximum: Settings.size.length_max_255}

  scope :show_user, -> {select :id, :name, :email, :phone, :address, :is_admin}
  scope :show_user_desc, -> {order created_at: :desc}

  def self.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
             BCrypt::Engine.cost
    BCrypt::Password.create string, cost: cost
  end

  def default_admin
    self.is_admin ||= false
  end
end
