class ProductAlreadyAttachedValidator < ActiveModel::Validator
  def validate(record)
    unless AttachedProduct.find_by(product_id: record.product_id,
        attachable_type: record.attachable_type,
        attachable_id: record.attachable_id).nil?
      record.errors[:base] << I18n.t('activerecord.errors.models.attached_product.
                                     product.uniqueness', product: record.product.name)
    end
  end
end
