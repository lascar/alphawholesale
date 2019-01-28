class Offer < ApplicationRecord
  belongs_to :supplier
  belongs_to :product
  belongs_to :variety, optional: true
  belongs_to :aspect, optional: true
  belongs_to :size, optional: true
  belongs_to :packaging, optional: true
  validates :supplier, presence: true
  validates :product, presence: true

  def product_name
    product ? product.name : nil
  end

  def variety_name
    variety ? variety.name : nil
  end

  def aspect_name
    aspect ?  aspect.name : nil
  end

  def packaging_name
    packaging ? packaging.name : nil
  end

  def supplier_currency
    supplier ? supplier.currency : nil
  end

  def self.by_supplier(supplier_id)
    where(supplier_id: supplier_id)
  end

  def self.with_approved(approved)
    where(approved: approved)
  end

  def self.not_expired
    where('date_end >= ?', Time.now)
  end
end
