class SendSupplierOfferApprovalJob < ApplicationJob
  queue_as :default

  def perform(offer)
    SupplierMailer.with(offer: offer).offer_approval.deliver_later
  end
end
