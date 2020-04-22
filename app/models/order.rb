class Order < ApplicationRecord
  include HasConcreteProductConcern
  belongs_to :customer
  validates :customer, presence: true
  belongs_to :offer
  validates :offer, presence: true
  before_create :bring_concrete_product
  after_commit :send_order_approval_if_approved
  after_update :warn_interested

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

  private
  def send_order_approval_if_approved
    if previous_changes["approved"] == [false, true]
      SendCustomerOrderApprovalJob.perform_later(self)
    end
  end

  def bring_concrete_product
    self.concrete_product_id = offer.concrete_product_id
  end

  def warn_interested
    if approved
      WarnInterestedJob.perform_later(object: self, object_type: 'order', user_class: 'Supplier')
    end
  end

end
