class WarnInterestedJob < ApplicationJob
  queue_as :default

  def perform(object:, object_type:, user_class:)
    list_interested = make_list_interested(object.concrete_product, user_class)
    list_interested.each do |user|
      UserMailer.with(user: user, object: object, object_type: object_type).
        object_update.deliver_later
    end
  end

  def make_list_interested(concrete_product, user_class)
    UserConcreteProduct.where(concrete_product_id: concrete_product.id, user_type: user_class).map(&:user)
  end

end
