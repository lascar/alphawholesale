class AttachedProduct < ApplicationRecord
  belongs_to :attachable, polymorphic: true
  validates :definition, uniqueness: { scope: :attachable }

  def variety
    definition["variety"]
  end

  def aspect
    definition["aspect"]
  end

  def packaging
    definition["packaging"]
  end

  def size
    definition["size"]
  end

  def caliber
    definition["caliber"]
  end

end
