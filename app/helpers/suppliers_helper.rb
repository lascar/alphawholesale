module SuppliersHelper

  def suppliers_index_path
    suppliers_path
  end

  def supplier_show_path(supplier)
    if supplier_signed_in?
      supplier_path(current_supplier)
    else
      supplier_path(supplier)
    end
  end

  def supplier_edit_path(supplier)
    edit_supplier_path(supplier)
  end

  def supplier_new_path
    new_supplier_path
  end

end
