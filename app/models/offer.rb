class Offer < ApplicationRecord
  belongs_to :supplier
  belongs_to :concrete_product
  has_many :orders
  validates :supplier, presence: true
  validates :concrete_product, presence: true
  after_save :send_offer_approval_if_approved
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

  def currency
    supplier.currency
  end

  def unit_type
    supplier.unit_type
  end

  def self.not_expired
    where('date_end >= ?', Time.now)
  end

  private
  def send_offer_approval_if_approved
    if previous_changes["approved"] == [false, true]
      SendSupplierOfferApprovalJob.perform_later(self)
    end
  end

  def warn_interested
    WarnInterestedJob.perform_later(object: self, object_type: 'offer', user_class: 'Customer')
  end

end
