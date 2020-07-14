class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable
  validates :torn_user_id, uniqueness: true
  
  has_many :prices
  has_many :items, through: :prices
  has_many :messages
  accepts_nested_attributes_for :prices

  has_many :trades
  has_many :subscriptions
  
  validate :validate_torn_user_id
  validates :torn_user_id, presence: true, uniqueness: { case_sensitive: false }, numericality: { only_integer: true }
  validate :has_five_messages_atmost

  enum user_type: %w[general admin]
  enum auto_update: %w[auto_updated_not auto_updated]
  enum pricing_rules: %w[percentage fixed]
  enum global_pricing: %w[disable_global enable_global]
  
  attr_writer :login

  def has_five_messages_atmost
    errors.add :user_id, "Only 5 messages are allowed!" if messages.count > 5
  end

  def validate_torn_user_id
    if !ConfirmUser.execute(self.torn_api_key, self.torn_user_id)
      errors.add(:torn_user_id, "Wrong api key or user id, try again")
    end
  end

  def login
    @login || self.torn_user_id
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(torn_user_id) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:torn_user_id) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end
end
