class Offer < ApplicationRecord
  belongs_to :supplier
  belongs_to :attached_product
  has_many :orders
  validates :supplier, presence: true
  validates :attached_product, presence: true
  after_save :send_offer_approval_if_approved
 
  def product_name
    attached_product.product
  end

  def variety_name
    attached_product.variety
  end

  def aspect_name
    attached_product.aspect
  end

  def packaging_name
    attached_product.packaging
  end

  def size_name
    attached_product.size
  end

  def caliber_name
    attached_product.caliber
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
end
