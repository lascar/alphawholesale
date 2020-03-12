class SendSupplierOfferApprovalJob < ApplicationJob
  queue_as :default

  def perform(offer)
    UserMailer.with(offer: offer).offer_approval.deliver_later
  end
end
