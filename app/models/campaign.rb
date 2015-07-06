class Campaign < ActiveRecord::Base
  has_many :campaign_offers, dependent: :destroy
  has_many :offers, through: :campaign_offers
  accepts_nested_attributes_for :offers
  validates :name, presence: true

  before_destroy :check_active_offers, prepend: true

  protected

  def check_active_offers
    active_offers = offers.where('finish > ?', Time.zone.today).any?
    errors[:base] << 'There are currently active offers on this campaign.' if active_offers
    !active_offers
  end
end
