class Response < ApplicationRecord
  include HasConcreteProductConcern
  belongs_to :supplier
  belongs_to :request
  validates :supplier, presence: true
  validates :request, presence: true
  before_create :bring_concrete_product
  after_commit :send_response_approval_if_approved
  after_update :warn_interested

  def currency
    request.currency
  end

  def unit_type
    request.unit_type
  end

  def self.not_expired
    joins(:request).where('requests.date_end >= ?', Time.now)
  end

  private
  def send_response_approval_if_approved
    if previous_changes["approved"] == [false, true]
      SendSupplierResponseApprovalJob.perform_later(self)
    end
  end

  def bring_concrete_product
    self.concrete_product_id = request.concrete_product_id
  end

  def send_response_approval_if_approved
    if previous_changes["approved"] == [false, true]
      SendSupplierResponseApprovalJob.perform_later(self)
    end
  end

  def warn_interested
    if approved
      WarnInterestedJob.perform_later(object: self, object_type: 'response', user_class: 'Customer')
    end
  end
end
