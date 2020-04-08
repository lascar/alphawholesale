class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :concrete_product, optional: true
  validates :customer, presence: true
  belongs_to :offer
  validates :offer, presence: true
  before_create :bring_concrete_product
  after_update :warn_interested

  def product_name
    concrete_product.product
  end

  def variety_name
    concrete_product.variety
  end

  def aspect_name
    concrete_product.aspect
  end

  def packaging_name
    concrete_product.packaging
  end

  def size_name
    concrete_product.size
  end

  def caliber_name
    concrete_product.caliber
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
    offer.supplier_observation
  end

  def date_start
    offer.date_start
  end

  def date_end
    offer.date_end
  end

  def self.not_expired
    joins(:offer).where('offers.date_end >= ?', Time.now)
  end

  def bring_concrete_product
    self.concrete_product_id = offer.concrete_product_id
  end

  def warn_interested
    WarnInterestedJob.perform_later(object: self, object_type: 'order', user_class: 'Supplier')
  end

end
