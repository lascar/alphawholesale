class UserAttachedProduct < ApplicationRecord
  belongs_to :attached_product
  belongs_to :user, polymorphic: true
end
