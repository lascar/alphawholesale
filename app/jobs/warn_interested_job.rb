class WarnInterestedJob < ApplicationJob
  queue_as :default

  def perform(object:, object_type:, user_class:)
    product = Product.find_by_name(object.concrete_product.product)
    list_interested = make_list_interested(product, user_class)
    list_interested.each do |user|
      UserMailer.with(user: user, object: object, object_type: object_type).
        object_update.deliver_later
    end
  end

  def make_list_interested(product, user_class)
    UserProduct.where(product_id: product.id, user_type: user_class).map(&:user)
  end

end
