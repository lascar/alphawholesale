module HasConcreteProductConcern
  extend ActiveSupport::Concern

  included do
    belongs_to :concrete_product, optional: true
  end

  def product_name
    concrete_product.product
  end

  def variety_name
    concrete_product.variety
  end

  def aspect_name
    concrete_product.aspect
  end

  def packaging_name
    concrete_product.packaging
  end

  def size_name
    concrete_product.size
  end

  def caliber_name
    concrete_product.caliber
  end

end
