class UserConcreteProduct < ApplicationRecord
  belongs_to :concrete_product
  belongs_to :user, polymorphic: true
  validate :concrete_product_uniqueness
  validates :concrete_product, uniqueness: { scope: [:user_type, :user_id]}
  # validates :user, uniqueness: {scope: :concrete_product}

  private
  def concrete_product_uniqueness
    if self.new_record?
      user_concrete_product = UserConcreteProduct.unscoped.find_by(user_id: user_id, user_type: user_type, concrete_product_id: concrete_product_id)
      if user_concrete_product
        errors.add(:concrete_product, :taken)
      end
    end
  end
end
