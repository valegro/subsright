class Product < ActiveRecord::Base
  has_and_belongs_to_many :offers
  accepts_nested_attributes_for :offers
  validates_presence_of :name
  has_attached_file :image, styles: { thumb: '100x100>' }
  validates_attachment_content_type :image, :content_type => /\Aimage\//
end
