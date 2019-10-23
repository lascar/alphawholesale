class AlreadyAttachedValidator < ActiveModel::Validator
  def validate(record)
    unless AttachedProduct.unscoped.find_by(product_id: record.product_id,
        variety_id: record.variety&.id,
        aspect_id: record.aspect&.id,
        packaging_id: record.packaging&.id,
        attachable_type: record.attachable_type,
        attachable_id: record.attachable_id).nil?
      record.errors[:base] << I18n.t('activerecord.errors.models.attached_product.uniqueness')
    end
  end
end
