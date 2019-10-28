class AttachedProduct < ApplicationRecord
  belongs_to :product
  belongs_to :variety, optional: true
  belongs_to :aspect, optional: true
  belongs_to :packaging, optional: true
  belongs_to :attachable, polymorphic: true
  validate :broker_attached
  validate :product_approved
  validate :already_attached

  private
  def already_attached
    unless AttachedProduct.unscoped.find_by(product_id: product_id,
        variety_id: variety&.id, aspect_id: aspect&.id, packaging_id: packaging&.id,
        attachable_type: attachable_type, attachable_id: attachable_id).nil?
      errors[:base] << I18n.t('activerecord.errors.models.attached_product.uniqueness')
    end
  end

  def product_approved
    unless product.approved
      errors[:base] << I18n.t('activerecord.errors.models.attached_product.product.not_approved', product: product.name)
    end
  end

  def broker_attached
    unless attachable_type == 'Broker' || AttachedProduct.find_by(product_id: product_id,
        variety_id: variety_id, aspect_id: aspect_id, packaging_id: packaging_id,
        attachable_type: 'Broker')
      errors[:base] << I18n.t('activerecord.errors.models.attached_product.not_attachable')
    end
  end
end
