module SizesHelper
  def size_show_path(size)
    if supplier_signed_in?
      supplier_size_path(current_supplier.id, size)
    else
      size_path(size)
    end
  end

  def size_new_path(supplier_id)
    if supplier_signed_in?
      new_supplier_size_path(supplier_id)
    else
      new_size_path
    end
  end

end
