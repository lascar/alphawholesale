module PackagingsHelper
  def packaging_show_path
    if supplier_signed_in?
      supplier_packaging_path(@packaging.id, supplier_id: current_supplier.id)
    else
      packaging_path(@packaging.id)
    end
  end

  def packaging_new_path
    if supplier_signed_in?
      new_supplier_packaging_path(current_supplier)
    else
      new_packaging_path
    end
  end
end
