class SendCustomerOrderApprovalJob < ApplicationJob
  queue_as :default

  def perform(order)
    UserMailer.with(order: order).order_approval.deliver_later
  end
end
