class Request < ApplicationRecord
  include HasConcreteProductConcern
  belongs_to :customer
  has_many :responses
  validates :customer, presence: true
  validates :concrete_product, presence: true
  after_commit :send_offer_approval_if_approved
  after_update :warn_interested

  def self.not_expired
    where('date_end >= ?', Time.now)
  end

  def currency
    customer.currency
  end

  def unit_type
    customer.unit_type
  end

  private
  def send_offer_approval_if_approved
    if previous_changes["approved"] == [false, true]
      SendCustomerRequestApprovalJob.perform_later(self)
    end
  end

  def warn_interested
    if approved
      WarnInterestedJob.perform_later(object: self, object_type: 'request', user_class: 'Supplier')
    end
  end

end
