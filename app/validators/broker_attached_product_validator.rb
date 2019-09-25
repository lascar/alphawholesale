class BrokerAttachedProductValidator < ActiveModel::Validator
  def validate(record)
    unless record.attachable_type == 'Broker' || AttachedProduct.find_by(product_id: record.product_id,
        variety_id: record.variety_id, aspect_id: record.aspect_id,
        packaging_id: record.packaging_id,
        attachable_type: 'Broker')
      record.errors[:base] << I18n.t('activerecord.errors.models.attached_product.not_attachable')
    end
  end
end
