class Price < ActiveRecord::Base
  has_and_belongs_to_many :offers
  accepts_nested_attributes_for :offers
  has_and_belongs_to_many :discounts
  accepts_nested_attributes_for :discounts
  validates_presence_of :currency, :amount
  validates :name, presence: true, uniqueness: { scope: :currency }
end
