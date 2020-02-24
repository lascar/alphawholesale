class Order < ApplicationRecord
  belongs_to :customer
  validates :customer, presence: true
  belongs_to :offer
  validates :offer, presence: true

  def product_name
    offer.product_name
  end

  def variety_name
    offer.variety_name
  end

  def aspect_name
    offer.aspect_name
  end

  def packaging_name
    offer.packaging_name
  end

  def size_name
    offer.size_name
  end

  def caliber_name
    offer.caliber_name
  end

  def unit_price_broker
    offer.unit_price_broker
  end

  def unit_price_supplier
    offer.unit_price_supplier
  end

  def localisation_broker
    offer.localisation_broker
  end

  def localisation_supplier
    offer.localisation_supplier
  end

  def currency
    offer.currency
  end

  def incoterm
    offer.incoterm
  end

  def unit_type
    offer.unit_type
  end

  def supplier_observation
    offer.observation
  end

  def self.not_expired
    joins(:offer).where('offers.date_end >= ?', Time.now)
  end

end
