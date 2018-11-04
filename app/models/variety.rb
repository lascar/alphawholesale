class Variety < ApplicationRecord
  belongs_to :product
  belongs_to :supplier, optional: true
  has_many :offer
  has_many :order_lines
  has_many :tender_lines
  validates :name, uniqueness: { scope: [:product_id] }

  def self.with_approved(approved)
    where(approved: approved)
  end
end
