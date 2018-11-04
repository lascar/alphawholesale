class Order < ApplicationRecord
  belongs_to :customer
  validates :customer, presence: true
  belongs_to :offer
  validates :offer, presence: true

  def self.with_approved(approved)
    where(approved: approved)
  end
end
