class Product < ApplicationRecord
  after_create :generate_reference
  belongs_to :supplier, optional: true
  has_many :offers
  has_many :order_lines
  has_many :tender_lines
  has_many :product_suppliers, dependent: :delete_all
  has_many :suppliers, through: :product_suppliers
  validates :name, presence: true, allow_blank: false
  validates :name, uniqueness: { scope: [:variety] }
  has_many :varieties
  has_many :packagings
  has_many :aspects
  has_many :sizes

  def generate_reference
    self.update_column(:reference, id.to_s.rjust(9, '0'))
  end

  def name_complete
    name.to_s + ' ' + variety.to_s
  end

  def self.get_names
    Product.pluck(:name).uniq
  end

  def self.not_owned_by_other_supplier(supplier_id)
    Product.where(supplier_id: nil) + Product.where(supplier_id: supplier_id)
  end

  def self.with_approved(approved)
    where(approved: approved)
  end
end
