class AttachedProduct < ApplicationRecord
  belongs_to :product
  belongs_to :variety, optional: true
  belongs_to :aspect, optional: true
  belongs_to :packaging, optional: true
  belongs_to :attachable, polymorphic: true
  validates_with BrokerAttachedProductValidator
  validates_with ProductApprovedValidator
  validates_with ProductAlreadyAttachedValidator
end
