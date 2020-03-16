class WarnInterestedJob < ApplicationJob
  queue_as :default

  def perform(offer)
    list_interested = make_list_interested(offer.attached_product)
    list_interested.each do |user|
      UserMailer.with(user: user, offer: offer).offer_update.deliver_later
    end
    # SupplierMailer.with(offer: offer).offer_approval.deliver_later
  end

  def make_list_interested(attached_product)
    Customer.interested_in(attached_product)
  end

end
