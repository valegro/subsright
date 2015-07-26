class User < ActiveRecord::Base
  # :omniauthable is also available
  devise :confirmable, :database_authenticatable, :lockable,
         :recoverable, :rememberable, :timeoutable, :trackable, :validatable

  has_many :customers
  accepts_nested_attributes_for :customers, allow_destroy: true
  has_many :subscriptions

  validates :name, presence: true
  before_validation :generate_password, on: :create

  def currency_name
    return if currency.blank?
    m = Money::Currency.new(currency)
    "#{m.name} (#{m.iso_code})"
  end

  def password_match?
    errors[:password] << "can't be blank" if password.blank?
    errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    errors[:password_confirmation] << 'does not match password' if password != password_confirmation
    password == password_confirmation && !password.blank?
  end

  def generate_password
    self.password_confirmation = self.password = Devise.friendly_token if password.nil? || password.blank?
  end
end
