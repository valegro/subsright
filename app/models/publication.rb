class Publication < ActiveRecord::Base
  has_many :offers, through: :offer_publications
  accepts_nested_attributes_for :offers
  has_many :offer_publications
  accepts_nested_attributes_for :offer_publications
  validates :name, presence: true, uniqueness: true
  validates_presence_of :website
  validates_format_of :website, with: URI.regexp, if: 'website.present?'
  has_attached_file :image, styles: { thumb: '100x100#' }, convert_options: { thumb: '-strip -quality 75' }
  validates_attachment_content_type :image, content_type: %r{\Aimage/}
end
