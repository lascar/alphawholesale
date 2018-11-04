class Tender < ApplicationRecord
  belongs_to :customer
  validates :customer, presence: true
  has_many :tender_lines, dependent: :destroy

  def total
    tender_lines.reduce(0) do |sum, tender_line|
      sum + (tender_line.unit * tender_line.unit_price)
    end
  end

  def self.with_approved(approved)
    where(approved: approved)
  end
end
