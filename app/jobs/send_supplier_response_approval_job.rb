class SendSupplierResponseApprovalJob < ApplicationJob
  queue_as :default

  def perform(order)
    UserMailer.with(order: order).response_approval.deliver_later
  end
end
