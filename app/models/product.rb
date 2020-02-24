class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: true, allow_blank: false

  def varieties
    assortments['varieties']
  end

  def aspects
    assortments['aspects']
  end

  def packagings
    assortments['packagings']
  end

  def sizes
    assortments['sizes']
  end

  def calibers
    assortments['calibers']
  end

end
