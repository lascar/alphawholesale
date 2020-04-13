class Offer < ApplicationRecord
  include HasConcreteProductConcern
  belongs_to :supplier
  has_many :orders
  validates :supplier, presence: true
  validates :concrete_product, presence: true
  after_commit :send_offer_approval_if_approved
  after_update :warn_interested
 
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
    if approved
      WarnInterestedJob.perform_later(object: self, object_type: 'offer', user_class: 'Customer')
    end
  end

end
