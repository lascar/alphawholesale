class AttachedProduct < ApplicationRecord
  belongs_to :product
  belongs_to :attachable, polymorphic: true
  validates_with ProductApprovedValidator
  validates_with ProductAlreadyAttachedValidator
end
