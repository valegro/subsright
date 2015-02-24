class Product < ActiveRecord::Base
  has_and_belongs_to_many :offers
  accepts_nested_attributes_for :offers
  validates_presence_of :name
end
