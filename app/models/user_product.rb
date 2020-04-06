class UserProduct < ApplicationRecord
  belongs_to :user, polymorphic: true
  belongs_to :product
end
