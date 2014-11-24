class AdminUser < ActiveRecord::Base
  # :omniauthable is also available
  devise :confirmable, :database_authenticatable, :lockable, 
         :recoverable, :rememberable, :timeoutable, :trackable, :validatable

  validates_presence_of :name
end
