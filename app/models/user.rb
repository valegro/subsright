class User < ActiveRecord::Base
  # :omniauthable is also available
  devise :confirmable, :database_authenticatable, :lockable,
         :recoverable, :rememberable, :timeoutable, :trackable, :validatable

  has_many :customers
  accepts_nested_attributes_for :customers, allow_destroy: true
  validates :name, presence: true
end
