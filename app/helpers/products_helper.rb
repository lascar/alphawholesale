module ProductsHelper
  def list_products_path
    if supplier_signed_in?
      supplier_products_path(current_supplier)
    else
      products_path
    end
  end

  def link_new_product_path
    if supplier_signed_in?
      new_supplier_product_path(current_supplier)
    else
      new_product_path
    end
  end
end
