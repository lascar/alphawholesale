class UserAttachedProduct < ApplicationRecord
  belongs_to :attached_product
  belongs_to :user, polymorphic: true
  validate :attached_product_uniqueness
  validates :attached_product, uniqueness: { scope: [:user_type, :user_id]}
  # validates :user, uniqueness: {scope: :attached_product}

  private
  def attached_product_uniqueness
    if self.new_record?
      user_attached_product = UserAttachedProduct.unscoped.find_by(user_id: user_id, user_type: user_type, attached_product_id: attached_product_id)
      if user_attached_product
        errors.add(:attached_product, :taken)
      end
    end
  end
end
