class Discount < ActiveRecord::Base
  has_and_belongs_to_many :prices
  accepts_nested_attributes_for :prices
  validates :name, presence: true, uniqueness: true
end
