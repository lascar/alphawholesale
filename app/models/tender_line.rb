class TenderLine < ApplicationRecord
  belongs_to :tender
  belongs_to :product
  belongs_to :aspect, optional: true
  belongs_to :size, optional: true
  belongs_to :variety, optional: true
  belongs_to :packaging, optional: true
  validates :product, presence: true
  validates :tender, presence: true

  def self.by_tender(tender_id)
    if tender_id
      where(tender_id: tender_id)
    else
      all
    end
  end

  def self.by_approved(approved)
    tenders = Tender.with_approved(approved)
    return tenders.reduce([]) do |tender_lines, tender|
      tender_lines << tender.tender_lines
      return tender_lines
    end
  end
end
