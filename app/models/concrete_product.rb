class ConcreteProduct < ApplicationRecord
  has_many :user_concrete_products
  has_many :customers, through: :user_concrete_products, source: :user, source_type: 'Customer'
  has_many :suppliers, through: :user_concrete_products, source: :user, source_type: 'Supplier'

  validates :product, uniqueness: {scope: [:variety, :aspect, :packaging, :size, :caliber]}
end
