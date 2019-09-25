class ProductApprovedValidator < ActiveModel::Validator
  def validate(record)
    unless record.product.approved
      record.errors[:base] << I18n.t('activerecord.errors.models.attached_product.product.not_approved', product: record.product.name)
    end
  end
end
