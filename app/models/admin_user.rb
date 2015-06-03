class AdminUser < ActiveRecord::Base
  # :omniauthable is also available
  devise :confirmable, :database_authenticatable, :lockable,
         :recoverable, :rememberable, :timeoutable, :trackable, :validatable

  validates :name, presence: true
  before_validation :generate_password, on: :create

  def generate_password
    self.password_confirmation = self.password = Devise.friendly_token if password.nil? || password.blank?
  end
end
