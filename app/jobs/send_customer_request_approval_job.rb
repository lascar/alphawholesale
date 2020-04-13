class SendCustomerRequestApprovalJob < ApplicationJob
  queue_as :default

  def perform(offer)
    UserMailer.with(request: request).request_approval.deliver_later
  end
end
